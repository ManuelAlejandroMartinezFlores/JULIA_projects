using OhMyREPL


f(x) = x < 0.3 ? 0 : x < 0.7 ? 0.5 : 0.6
g(y) = y < 0.3 ? 0.3 : y < 0.7 ? 0 : 0.6

p = rand(100)

x = f.(p) + randn(100) .* 0.12
y = g.(p) + randn(100) .* 0.12



using Plots

scatter(x, y, color=:dodgerblue, legend=false)

X = [x y]'

k = 3 

itr = 100

result = kmeans(X, k, maxiter = itr, display = :iter)

mu = result.centers


scatter(x, y, group=result.assignments)
scatter!(mu[1, :], mu[2, :], label="centers", color=:yellow, markersize=5)

