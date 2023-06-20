using DifferentialEquations, DiffEqFlux, Flux

using AdvancedHMC, MCMCChains, Plots

using ComponentArrays, Random 

u0 = [2.; 0.]

datasize = 100

t0 = 0.
tf = 10.

t = range(t0, tf, datasize)

function trueODE!(du, u, p, t)
    trueA = [-0.1 2.; -2. -0.1]
    du .= ((u .^ 3)' * trueA)'
end

prob_true = ODEProblem(trueODE!, u0, (t0, tf))

sol_true = solve(prob_true)

plot(sol_true)
plot(sol_true(t)[1, :], sol_true(t)[2, :])


true_data = sol_true(t)

##############################################
# Neural ODE 
##############################################

dudt2 = Flux.Chain(x -> x .^ 3, 
    Flux.Dense(2, 50, tanh),
    Flux.Dense(50, 2)
) |> f64



prob_neural = NeuralODE(
    dudt2, (t0, tf), Tsit5(), saveat=t
)

p = Float64.(prob_neural.p)


predict_neural(p) = Array(prob_neural(u0, p))
function loss_neural(p)
    pred = predict_neural(p)
    sum(abs2, true_data .- pred), pred
end

loss(theta) = -sum(abs2, true_data .- predict_neural(theta)) - sum(theta .* theta)

function dlossdtheta(theta)
    x,lambda = Flux.Zygote.pullback(loss, theta)
    grad = first(lambda(1))
    x, grad 
end

metric = DiagEuclideanMetric(length(p))

hamiltonian = Hamiltonian(metric, loss, dlossdtheta)

integrator = Leapfrog(
    find_good_stepsize(hamiltonian, p)
)

proposal = AdvancedHMC.NUTS{
    MultinomialTS, GeneralisedNoUTurn
}(integrator)

adaptor = StanHMCAdaptor(
    MassMatrixAdaptor(metric),
    StepSizeAdaptor(0.45, integrator)
)


nsamples = 50

samples, stats = sample(hamiltonian, proposal, p, nsamples, adaptor, nsamples; progress=true)

samplesm = hcat(samples...)



fig = plot(sol_true, linewidth=3)
for k in 1:20
    res = predict_neural(samplesm[:, 29 + k])
    plot!(t, res[1, :], color=:blue, alpha=0.1, label=false)
    plot!(t, res[2, :], color=:red, alpha=0.1, label=false)
end

fig