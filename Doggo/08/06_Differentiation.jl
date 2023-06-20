using ForwardDiff

f(x) = (x - 1) * (x - 3) * (x + 2)

using Plots

x = -5:0.1:5

fp = ForwardDiff.derivative.(f, x)

plot(x, f)
plot!(x, fp)


using ReverseDiff


A, B = rand(20, 20), rand(20, 20)

f(A, B) = sum(A' * B + A * B')

ReverseDiff.gradient(f, (A, B))