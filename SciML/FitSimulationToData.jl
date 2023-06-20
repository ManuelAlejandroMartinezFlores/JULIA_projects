using DifferentialEquations, Optimization, OptimizationPolyalgorithms, SciMLSensitivity
using ForwardDiff, Plots

##############################################################
# Generate Data 
##############################################################

function lotka_volterra!(du, u, p, t)
    x, y = u 
    a, b, g, d = p 
    du[1] = a * x - b * x * y 
    du[2] = -d * y + g * x * y 
end

u0 = [1., 1.]
p = [1.5, 1., 3., 1.]

prob = ODEProblem(lotka_volterra!, u0, (0., 10.), p)
datasol = solve(prob, saveat=1)
data = Array(datasol)

##############################################################
# Define loss
##############################################################

function loss(newp)
    newprob = remake(prob, p=newp)
    sol = solve(newprob, saveat=1)
    loss = sum(abs2, sol .- data)
    return loss, sol 
end

function callback(p, l, sol)
    display(l)
    plt = plot(sol, ylim=(0, 6), label="Current Prediction")
    scatter!(plt, datasol, label="Data")
    display(plt)
    return false 
end

##############################################################
# Solve
##############################################################

adtype = Optimization.AutoForwardDiff()
optf = Optimization.OptimizationFunction((x, p) -> loss(x), adtype)
pguess = [1., 1.2, 2.5, 1.2]
optprob = Optimization.OptimizationProblem(optf, pguess)

result_ode = Optimization.solve(optprob, PolyOpt(), callback=callback, maxiters=10)