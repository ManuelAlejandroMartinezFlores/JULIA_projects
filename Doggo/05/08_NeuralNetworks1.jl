using Flux, Images, MLDatasets, Plots

using Flux: crossentropy, onecold, onehotbatch, train!

using LinearAlgebra, Random, Statistics

xtrain, ytrain = MLDatasets.MNIST(split=:train)[:]

xtest, ytest = MNIST(:test)[:]

xtrain = Flux.flatten(xtrain)
xtest = Flux.flatten(xtest)

ytrain = onehotbatch(ytrain, 0:9)
ytest = onehotbatch(ytest, 0:9)


model = Chain(
    Dense(28 * 28, 64, relu),
    Dense(64, 32, relu), 
    Dense(32, 10), softmax
)

loss(x, y) = crossentropy(model(x), y)

ps = Flux.params(model)

lr = 0.01

opt = ADAM(lr)

trainlos = []
vallos = []


for epoch in 1:100
    train!(loss, ps, [(xtrain, ytrain)], opt)
    push!(trainlos, loss(xtrain, ytrain))
    push!(vallos, loss(xtest, ytest))
    println("epoch: $epoch")
end

plot(trainlos, label="train")
plot!(vallos, label="test")



yhat = model(xtest)

yhat = onecold(yhat) .- 1

mean(yhat .== onecold(ytest) .- 1)

yhat = model(xtrain)

yhat = onecold(yhat) .- 1

mean(yhat .== onecold(ytrain) .- 1)