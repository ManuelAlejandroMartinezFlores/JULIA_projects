using OrdinaryDiffEq, ModelingToolkit, DataDrivenDiffEq, SciMLSensitivity, DataDrivenSparse
using Optimization, OptimizationOptimisers, OptimizationOptimJL
using LinearAlgebra, Statistics

using ComponentArrays, Lux, Zygote, Plots, StableRNGs


rng = StableRNG(1111)


######################################################
# Generating Data 
######################################################

function lotka!(du, u, p, t)
    a, b, g, d = p 
    du[1] = a * u[1] - b * u[1] * u[2]
    du[2] = g * u[1] * u[2] - d * u[2]
end

tspan = (0., 5.)
u0 = 5.0f0 * rand(rng, 2)
p_ = [1.3, 0.9, 0.8, 1.8]
prob = ODEProblem(lotka!, u0, tspan, p_)
solution = solve(prob, Vern7(), abstol=1e-12, reltol=1e-12, saveat=0.25)

X = Array(solution)
t = solution.t

Xb = mean(X, dims=2)
noisemag = 5e-3
Xn = X .+ (noisemag * Xb) .* randn(rng, eltype(X), size(X))

plot(solution, alpha=0.7, color=:black, label=["True data" nothing])
scatter!(t, Xn', color=:red, label=["Noisy data" nothing])

######################################################
# Definition of Universal Differential Equation
######################################################

rbf(x) = exp.(- (x .^ 2))

U = Lux.Chain(
    Lux.Dense(2, 5, rbf), Lux.Dense(5, 5, rbf), Lux.Dense(5, 5, rbf), Lux.Dense(5, 2)
)
p, st = Lux.setup(rng, U)


function ude_dynamics!(du, u, p, t, p_true)
    uhat = U(u, p, st)[1]
    du[1] = p_true[1] * u[1] + uhat[1]
    du[2] = -p_true[4] * u[2] + uhat[2]
end

nn_dynamics!(du, u, p, t) = ude_dynamics!(du, u, p, t, p_)

prob_nn = ODEProblem(nn_dynamics!, Xn[:, 1], tspan, p)

######################################################
# Training
######################################################

function predict(theta, X=Xn[:, 1], T=t)
    _prob = remake(prob_nn, u0=X, tspan=(T[1], T[end]), p=theta)
    Array(solve(_prob, Vern7(), saveat=T, abstol=1e-6, reltol=1e-6))
end

function loss(theta)
    xhat = predict(theta)
    mean(abs2, Xn .- xhat)
end

losses = Float64[]

function callback(p, l)
    push!(losses, l)
    if length(losses) % 50 == 0
        println("Current loss after $(length(losses)) iterations: $(losses[end])")
    end
    return false
end


adtype = Optimization.AutoZygote()
optf = Optimization.OptimizationFunction((x, p) -> loss(x), adtype)
optprob = Optimization.OptimizationProblem(optf, ComponentVector{Float64}(p))

res1 = Optimization.solve(optprob, ADAM(), callback=callback, maxiters=5000)
println("Current loss after $(length(losses)) iterations: $(losses[end])")

optprob2 = Optimization.OptimizationProblem(optf, res1.u)
res2 = Optimization.solve(optprob2, Optim.LBFGS(), callback=callback, maxiters=1000)
println("Current loss after $(length(losses)) iterations: $(losses[end])")


p_trained = res2.u 


######################################################
# Visualizing
######################################################

pl_losses = plot(1:5000, losses[1:5000], yaxis=:log10, label="ADAM", color=:blue)
plot!(5001:length(losses), losses[5001:end], yaxis=:log10, label="BFGS")

ts = first(solution.t):(mean(diff(solution.t)) / 2):last(solution.t)

Xhat = predict(p_trained, Xn[:, 1], ts)

pl_trajectory = plot(ts, Xhat', color=:red, label=["UDE" nothing])
scatter!(solution.t, Xn', color=:black, label=["Measurements" nothing])


Yb = [-p_[2] * (Xhat[1, :] .* Xhat[2, :])' ; p_[3] * (Xhat[1, :] .* Xhat[2, :])']

Yhat = U(Xhat, p_trained, st)[1]

pl_rec = plot(ts, Yhat', color=:red, label=["UDE" nothing])
plot!(ts, Yb', color=:black, label=["True" nothing])

pl_rec_error = plot(ts, norm.(eachcol(Yb - Yhat)), yaxis=:log10, label=nothing, color=:red)
pl_missing = plot(pl_rec, pl_rec_error, layout=(2, 1))
pl_overall = plot(pl_trajectory, pl_missing)


######################################################
# Symbolic Regression
######################################################

@variables u[1:2]
b = polynomial_basis(u, 4)
basis = Basis(b, u)

full_problem = ContinuousDataDrivenProblem(Xn, t)

ideal_problem = DirectDataDrivenProblem(Xhat, Yb)

nn_problem = DirectDataDrivenProblem(Xhat, Yhat)

######################################################
# Full problem
######################################################

lambd = exp10.(-3:0.01:3)
opt = ADMM(lambd)

options = DataDrivenCommonOptions(
    maxiters = 10_000, normalize = DataNormalization(ZScoreTransform),
    selector = bic, digits = 1, 
    data_processing = DataProcessing(split=0.9, batchsize=30, shuffle=true, rng = StableRNG(1111))
)

ful_res = solve(full_problem, basis, opt, options=options)
full_eqs = get_basis(ful_res)
println(full_eqs)

######################################################
# Ideal problem
######################################################

ideal_res = solve(ideal_problem, basis, opt, options=options)
ideal_eqs = get_basis(ideal_res)
println(ideal_eqs)

######################################################
# NN problem
######################################################

nn_res = solve(nn_problem, basis, opt, options=options)
nn_eqs = get_basis(nn_res)
println(nn_eqs)


for eq in (full_eqs, ideal_eqs, nn_eqs)
    println(eq)
    println(get_parameter_map(eq))
    println()
end

function recovered_dynamics!(du, u, p, t)
    uhat = nn_eqs(u, p)
    du[1] = p_[1] * u[1] + uhat[1]
    du[2] = -p_[4] * u[2] + uhat[2]
end

estimation_prob = ODEProblem(recovered_dynamics!, u0, tspan, get_parameter_values(nn_eqs))
estimate = solve(estimation_prob, Tsit5(), saveat = solution.t)

plot(solution)
plot!(estimate)



function parameter_loss(p)
    Y = reduce(hcat, map(Base.Fix2(nn_eqs, p), eachcol(Xhat)))
    sum(abs2, Yhat .- Y)
end

optf = Optimization.OptimizationFunction((x, p) -> parameter_loss(x), adtype)
optprob = Optimization.OptimizationProblem(optf, get_parameter_values(nn_eqs))
parameter_res = Optimization.solve(optprob, Optim.LBFGS(), maxiters=1000)

######################################################
# Simulation
######################################################

tlong = (0., 50.)
estimation_prob = ODEProblem(recovered_dynamics!, u0, tlong, parameter_res)
estimate_long = solve(estimation_prob, Tsit5(thread=OrdinaryDiffEq.True()), saveat=0.1)
plot(estimate_long)

true_prob = ODEProblem(lotka!, u0, tlong, p_)
true_sol_long = solve(true_prob, Tsit5(thread=OrdinaryDiffEq.True()), saveat=0.1)
plot!(true_sol_long)