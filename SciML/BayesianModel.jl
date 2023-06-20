using DiffEqFlux, Flux, DifferentialEquations
using Random, Plots, AdvancedHMC, MCMCChains, StatsPlots, ComponentArrays

##########################################################
# Getting Data 
##########################################################

u0 = [2.; 0.]
datasize = 40
tspan = (0., 1.)
tsteps = range(tspan[1], tspan[2], datasize)
function trueODEfunc!(du, u, p, t)
    true_A = [-0.1 2.0; -2.0 -0.1]
    du .= ((u .^ 3)'true_A)'
end
trueprob = ODEProblem(trueODEfunc!, u0, tspan)
ode_data = Array(solve(trueprob, Tsit5(thread=OrdinaryDiffEq.True()), saveat=tsteps))

##########################################################
# Define Neural ODE
##########################################################

dudt2 = Flux.Chain(
    x -> x .^ 3,
    Flux.Dense(2, 50, tanh),
    Flux.Dense(50, 2)
) |> f64
prob_neural = NeuralODE(dudt2, tspan, Tsit5(thread=OrdinaryDiffEq.True()), saveat=tsteps)
rng = Random.default_rng()
p = Float64.(prob_neural.p)

function predict_neural(p)
    Array(prob_neural(u0, p))
end

function loss_neural(p)
    pred =  predict_neural(p)
    loss = sum(abs2, ode_data .- pred)
    loss, pred
end

##########################################################
# Bayesian Estimation
##########################################################

l(theta) = - sum(abs2, ode_data .- predict_neural(theta)) - sum(theta .* theta)
function dldtheta(theta)
    x, lambd = Flux.Zygote.pullback(l, theta)
    grad = first(lambd(1))
    return x, grad 
end

metric = DiagEuclideanMetric(length(p))
h = Hamiltonian(metric, l, dldtheta)

integrator = Leapfrog(find_good_stepsize(h, p))
prop = AdvancedHMC.NUTS{MultinomialTS, GeneralisedNoUTurn}(integrator)
adaptor = StanHMCAdaptor(MassMatrixAdaptor(metric), StepSizeAdaptor(0.45, integrator))
samples, stats = sample(h, prop, p, 50, adaptor, 50; progress=true)


samples = hcat(samples...)
samples_red = samples[1:5, :]
samples_res = reshape(samples_red, (50, 5, 1))

chain_spiral = Chains(samples_res)
plot(chain_spiral)

autocorplot(chain_spiral)

pl = scatter(tsteps, ode_data[1, :], color=:red, label="Data 1")
scatter!(tsteps, ode_data[2, :], color=:blue, label="Data 2")

for k in 1:100
    resol = predict_neural(samples[:, 30:end][:, rand(1:20)])
    plot!(tsteps, resol[1, :], alpha=0.07, color=:red, label=nothing)
    plot!(tsteps, resol[2, :], alpha=0.07, color=:blue, label=nothing)
end

pl

losses = map(x -> loss_neural(x)[1], eachcol(samples))
idx = findmin(losses)[2]
prediction = predict_neural(samples[:, idx])
plot!(tsteps, prediction[1, :], color=:black, label=nothing, w=2)
plot!(tsteps, prediction[2, :], color=:black, label="best prediction", w=2)







abstract type CustomSet{T} end


mutable struct FSet{T} <: CustomSet{T}
    h::T
    t::H where H <:CustomSet{T}
end


struct NilSet{T} <: CustomSet{T} end



CustomSet{T}() where T = NilSet{T}()
CustomSet() = CustomSet{Any}()

CustomSet(h::T, t::NilSet{T}) where T = FSet{T}(h, t)
c = CustomSet(1, NilSet{Int}())

CustomSet(h::T, t::FSet{T}) where T = FSet{T}(h, t)
CustomSet(1, c)

CustomSet(l::Array{T}) where T = length(l) == 0 ? CustomSet{T}() : CustomSet(first(l), length(l) > 1 ? CustomSet(l[2:end]) : CustomSet{T}())



CustomSet([1])
CustomSet([1])

CustomSet([])

CustomSet([1, 2])


isempty(s::NilSet) = true 
isempty(s::FSet) = s.h === missing

isempty(CustomSet(missing, CustomSet()))

import Base.in


in(x, c::NilSet) = false 

in(x, c::FSet) = x == c.h || in(x, c.t)

c = CustomSet([])
1 in c

s = CustomSet([1, 2])
2 in s


issubset(s::NilSet, c::H) where H<:CustomSet = true

issubset(c::FSet, s::NilSet) = false

issubset(s::FSet, S::FSet) = s.h in S && issubset(s.t, S)

s = CustomSet([1])
S = CustomSet([1, 2])

issubset(S, S)


disjoint(s::NilSet, c::H) where H<:CustomSet = true 
disjoint(s::H, c::NilSet) where H<:CustomSet = true 


n = CustomSet()

disjoint(n, S)
disjoint(S, n)

disjoint(s::FSet, c::FSet) = s.h in c || disjoint(s.t, c)

disjoint(s, S)

A = CustomSet([3, 4])
disjoint(s, A)


s1 = CustomSet([1])
s2 = CustomSet([1])



import Base.==

==(s1::NilSet, s2::NilSet) = true

CustomSet() == CustomSet()

==(s1::NilSet, s2::FSet) = false 
==(s1::FSet, s2::NilSet) = false

==(s1::FSet, s2::FSet) = issubset(s1, s2) && issubset(s2, s1)

s1 == s2

s1 == A

CustomSet(n::NilSet{T}) where T = NilSet{T}()
CustomSet(s::FSet{T})  where T = FSet{T}(s.h, s.t)

push!(c::NilSet, x) = FSet(x, c)
push!(c::FSet, x) = begin; c.t = CustomSet(c); c.h = x; c; end



s1 = CustomSet([1])

push!(s1, 2)
1 in s1
2 in s1 


s1 == CustomSet([1, 2])


################################################################################


intersect(s::NilSet, c::H) where H<:CustomSet = s 
intersect(s::FSet, c::FSet) = s.h in c ? push!(intersect!(s.t, c), s.h) : intersect!(s.t, c)


n1 = CustomSet()
n2 = CustomSet()

A = CustomSet([1, 2, 3])
B = CustomSet([2, 3])

s = CustomSet([])
isa(s, NilSet) ? s : s.t
intersect(A, B)

A

##################################################


complement(s::NilSet, c::H) where H<:CustomSet = s 
complement(s::FSet, c::H) where H<:CustomSet = s.h in c ? complement(s.t, c) : push!(complement(s.t, c), s.h)

A = CustomSet([1, 2, 3])
B = CustomSet([5, 3])

complement(A, B)
complement(B, A)

union(s::NilSet, c::H) where H<:CustomSet = c 
union(s::H, c::NilSet) where H<:CustomSet = s 


union(s::FSet, c::FSet) = s.h in c ? union(s.t, c) : push!(union(s.t, c), s.h)

union(A, B)