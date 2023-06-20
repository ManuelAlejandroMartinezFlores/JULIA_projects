using Plots, NearestNeighbors, Random

x = rand(100); y = rand(100);
data = [x y]'

scatter(x, y, color=:teal, legend=false)

kdtree = KDTree(data)

k = 11


test = [rand(); rand()]

scatter!([test[1]], [test[2]], color=:tomato, markersize=5)

index, dist = knn(kdtree, test, k, true)


scatter!(x[index], y[index], markercolor=:orange, alpha=0.5, markersize=8)


using RDatasets, StatsBase


iris = dataset("datasets", "iris")

function perclass_split(y, percent=0.75)
    u = unique(y)
    ans = []
    for c in u
        ind = findall(y .== c)
        ind = randsubseq(ind, percent)
        push!(ans, ind...)
    end 
    ans, setdiff(1:length(y), ans)
end

x = Matrix(iris[:, 1:4])
y = Vector{String}(iris.Species)

trainid, testid = perclass_split(y)

xtrain = x[trainid, :]'; ytrain = y[trainid]
xtest = x[testid, :]'; ytest = y[testid]


kdtree = KDTree(xtrain)


k = 5

index, dist = knn(kdtree, xtest, k, true)

index = [index...;;]'

classes = y[index]
yhat = argmax.(mapslices(countmap, classes, dims=2))

acc = mean(yhat .== ytest)