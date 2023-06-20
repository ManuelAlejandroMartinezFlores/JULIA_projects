using OhMyREPL


using LIBSVM, RDatasets 

using LinearAlgebra, Random, Statistics


iris = dataset("datasets", "iris")

X = Matrix(iris[:, 1:4])
Y = iris.Species

function perclass_split(y, percent=0.75)
    u = unique(y)
    ans = []
    for c in u
        ind = findall(y .== c)
        ind = randsubseq(ind, percent)
        push!(ans, ind...)
    end 
    ans, setdiff(1:length(Y), ans)
end

trainid, testid = perclass_split(Y)


Xtrain = X[trainid, :]'; Ytrain = Y[trainid]
Xtest = X[testid, :]'; Ytest = Y[testid]


model = svmtrain(Xtrain, Ytrain)

yhat, decision = svmpredict(model, Xtest)

acc = mean(yhat .== Ytest)



x = rand(100) .* 2 .- 1
y = rand(100) .* 2 .- 1

Y = sqrt.(x.^2 + y.^2) .< 0.7

X = [x y]'

using Plots 

c = [:tomato for _ in 1:100]
c[Y] .= :teal

scatter(x, y, label="data", markercolor=c)

model = svmtrain(X, Y)


yhat, decision = svmpredict(model, X)

decision = decision[1, :]


f(x, y) = svmpredict(model, [x y]')[2][1]
f(0, 0)

t = -1:0.05:1

heatmap(t, t, f, alpha=0.7)
scatter!(x, y, label="data", markercolor=c)

