using MultivariateStats, Plots


x = (0:0.01:1) .+ randn(101) .* 0.1
y = (0:0.01:1) .+ randn(101) .* 0.2


plotlyjs()

scatter(x, y, markersize=3)


X = [x y]'

model = fit(PCA, X; maxoutdim=1)

xt = MultivariateStats.transform(model, X)

xr = reconstruct(model, xt)

scatter!(xr[1, :], xr[2, :], markersize=3)


using RDatasets

iris = dataset("datasets", "iris")

X = Matrix(iris[:, 1:4])'
y = iris.Species


model = fit(PCA, X; maxoutdim = 2)

xt = MultivariateStats.transform(model, X)

scatter(xt[1, :], xt[2, :], group=y)