using OhMyREPL

using DecisionTree, Random, Statistics

X, y = load_data("iris")

X = float.(X)
y = string.(y)

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

trainid, testid = perclass_split(y)

xtrain = X[trainid, :]; ytrain = y[trainid]
xtest = X[testid, :]; ytest = y[testid]

##################################################
# DecisionTree
##################################################

model = DecisionTreeClassifier(max_depth=2)
fit!(model, xtrain, ytrain)

print_tree(model)

d = Dict("Iris-setosa" => 1, "Iris-versicolor" => 2, "Iris-virginica" => 3)


t = 0:0.1:8

tt = [t t t t]
f(x, y) = (x -> d[x]).(predict(model, [0 0 x y]))[1]


using Plots

heatmap(t, t, f, color=:blues)

cm = colormap("blues", 4)

scatter!(X[:, 3], X[:, 4], legend=false,
    markercolor=cm[(x -> d[x]).(y) .+ 1], markerstrokecolor=:white, strokewidth=2)

##################################################
# RandomForest
##################################################

model = RandomForestClassifier(n_trees=20, max_depth=2)

fit!(model, xtrain, ytrain)


d = Dict("Iris-setosa" => 1, "Iris-versicolor" => 2, "Iris-virginica" => 3)


t = 0:0.1:8

tt = [t t t t]
f(x, y) = (x -> d[x]).(predict(model, [0 0 x y]))[1]


using Plots

heatmap(t, t, f, color=:blues)

cm = colormap("blues", 4)

scatter!(X[:, 3], X[:, 4], legend=false,
    markercolor=cm[(x -> d[x]).(y) .+ 1], markerstrokecolor=:white, strokewidth=2)

##################################################
# AdaBoost
##################################################

model = AdaBoostStumpClassifier(n_iterations=20)

fit!(model, xtrain, ytrain)


d = Dict("Iris-setosa" => 1, "Iris-versicolor" => 2, "Iris-virginica" => 3)


t = 0:0.1:8

tt = [t t t t]
f(x, y) = (x -> d[x]).(predict(model, [0 0 x y]))[1]


using Plots

heatmap(t, t, f, color=:blues)

cm = colormap("blues", 4)

scatter!(X[:, 3], X[:, 4], legend=false,
    markercolor=cm[(x -> d[x]).(y) .+ 1], markerstrokecolor=:white, strokewidth=2)

model.ensemble