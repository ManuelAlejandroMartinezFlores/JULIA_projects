using Optimization, OptimizationNLopt, ForwardDiff

L(u, p) = (p[1] - u[1])^2 + p[2] * (u[2] - u[1]^2)^2

optfun = OptimizationFunction(L, Optimization.AutoForwardDiff())

u0 = zeros(2)
p = [1., 100.]
prob = OptimizationProblem(optfun, u0, p, lb=[-1., -1.], ub=[1., 1.])

sol = solve(prob, NLopt.LD_LBFGS())