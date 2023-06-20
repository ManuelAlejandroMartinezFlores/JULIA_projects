using ModelingToolkit, NonlinearSolve

@variables x=1. y=0. z=0.

@parameters s=10. r=26. b=8/3

eqs = [
    0 ~ s * (y - x),
    0 ~ x * (r - z) - y,
    0 ~ x * y - b * z 
]

@named ns = NonlinearSystem(eqs, [x, y, z], [s, r, b])

prob = NonlinearProblem(ns, [])

sol = solve(prob, NewtonRaphson())