using ModelingToolkit, DifferentialEquations, Plots 

@variables t x(t)=1 y(t)=1 z(t)=2

@parameters a=1.5 b=1. g=3. d=1.

D = Differential(t)

eqs = [
    D(x) ~ a * x - b * x * y ,
    D(y) ~ -g * y + d * x * y,
    z ~ x + y 
]

using Latexify

latexify(eqs)

@named sys = ODESystem(eqs, t)

simsys = structural_simplify(sys)

prob = ODEProblem(simsys, [], (0., 10.))
sol = solve(prob)

p1 = plot(sol)

p2 = plot(sol, idxs=z)

plot(p1, p2, layout=(2, 1))