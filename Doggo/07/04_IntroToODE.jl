using DifferentialEquations


f!(du, u, p, t) = begin; du[1] = u[1]; end

tspan = (0., 10.)

prob = ODEProblem(f!, [1.], tspan)

sol = solve(prob)

using Plots

plot(sol)




function lorenz!(du,u,p,t)
 du[1] = 10.0(u[2]-u[1])
 du[2] = u[1]*(28.0-u[3]) - u[2]
 du[3] = u[1]*u[2] - (8/3)*u[3]
end

u0 = [1.0;0.0;0.0]
tspan = (0.0,100.0)
prob = ODEProblem(lorenz!,u0,tspan)

### Test that it worked
sol = solve(prob,Tsit5())
plot(sol, vars=(1, 2, 3))
