using DifferentialEquations


function heat!(du, u, p, t)
    du[1] = 0.2 .* (u[2] - u[1]) ./ p[1]^2
    du[2:(end - 1)] = 0.2 .* (u[1:(end - 2)] .+ u[3:end] - 2 .* u[2:(end - 1)]) ./ p[1]^2
    du[end] = 0.2 .* (u[end - 1] - u[end]) ./ p[1]^2
end 



init(x) = x < 0.5 ? 0 : 100

dx = 0.01
x = collect(0:dx:1)
u = init.(x)


tspan = (0., 100.)

prob = ODEProblem(heat!, u, tspan, [dx])

sol = solve(prob, reltol=1e-8)

t = 0:0.01:1

m = Matrix(sol(t))

using Plots

heatmap(t, x, m)