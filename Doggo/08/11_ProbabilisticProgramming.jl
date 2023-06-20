using Distributions, StatsPlots


plot(Normal(0, 1), fillrange=0, alpha=0.5)

bar(Bernoulli(0.1), alpha=0.5)

plot(Beta(2, 1.5), fillrange=0, alpha=0.5)

using Turing, MCMCChains

##############################################
# WO Turing
##############################################

f = plot([0, 1], [0, 0], color=:black, label=false)
for tosses in 1:3
    tosses = 10^tosses
    p = 0.5

    data = rand(Bernoulli(p), tosses)
    h = sum(data)
    prior = Beta(1, 1)
    plot!(Beta(1 + h, 1 + tosses - h), fillrange=0, alpha=0.5, label="$tosses")
end
f

##############################################
# W Turing
##############################################

tosses = 1000

data = rand(Bernoulli(0.5), tosses)

@model function toss(; tosses)
    p ~ Beta(1, 1)
    y ~ filldist(Bernoulli(p), tosses)
    y
end

rand(toss(; tosses))

toss(y) = toss(; tosses = length(y)) | (; y)

model = toss(data)


sampler = NUTS()

chain = sample(model, sampler, 10000; progress=true)

plot(chain)