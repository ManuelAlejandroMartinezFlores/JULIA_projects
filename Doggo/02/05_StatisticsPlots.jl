obs = [144, 151, 157, 170, 152, 145, 175, 149, 99, 113, 140, 102, 135, 149, 149, 68, 136, 144, 72, 97]
t = collect(1:20)


using Plots 

gr(size = (800, 450))

pline = plot(t, obs,
    xlabel="time", ylabel="obs", title="GR", legend=false
)

pscatter = scatter(t, obs,
    xlabel="time", ylabel="obs", title="GR", legend=false, color=:dodgerblue, alpha=0.7
)


using Statistics 

avg = mean(obs)
st = std(obs)

hline!([avg - st, avg + st, avg], linestyle=:dash, color=:green)


using GLM, TypedTables

data = Table(X=t, Y=obs)

ols = lm(@formula(Y ~ X), data)

plot!(t, predict(ols), color=:red, alpha=0.7)




using StatsBase

K = Int(round(1 + 3.322log(length(obs))))

h = fit(Histogram, obs, nbins=K)

phist = bar(h.edges, h.weights, 
    xlabel="obs", ylabel="count", legend=false, color=:tomato, alpha=0.7
)

vline!([avg - st, avg, avg, avg + st], color=:green,
    linestyle=:dash)


using KernelDensity

d = kde(obs)

pdensity = plot(d.x, d.density, fill=(0, :tomato), color=:tomato, alpha=0.5)
vline!([avg - st, avg, avg, avg + st], color=:green,
    linestyle=:dash)



######################################
######################################


using StatsPlots

plotlyjs(size=(800, 450))

obs = [144, 151, 157, 170, 152, 145, 175, 149, 99, 113, 140, 102, 135, 149, 149, 68, 136, 144, 72, 97]
t = collect(1:20)

pscatter = scatter(t, obs, color=:dodgerblue, regression=true)

using Statistics 

avg = mean(obs)
st = std(obs)

hline!([avg - st, avg + st, avg], linestyle=:dash, color=:green)


K = Int(round(1 + 3.322log(length(obs))))


phist = histogram(obs, bins=K)

pden = density(obs, fill=(0, :dodgerblue))



######################################
######################################

obs = [144, 151, 157, 170, 152, 145, 175, 149, 99, 113, 140, 102, 135, 149, 149, 68, 136, 144, 72, 97]
t = collect(1:20)

using CairoMakie

fig = Figure(resolution=(1280, 720))

ax1 = Axis(fig[1, 1], title="Makie")
fig 

ac1 = scatter!(t, obs, color=(:dodgerblue, 0.5), markersize=21)
fig


using Statistics 

avg = mean(obs)
st = std(obs)

hlines!([avg - st, avg + st], linestyle=:dash, color=:orange, linewidth=3)
hlines!([avg], linestyle=:dash, color=:green, linewidth=3)
fig

using GLM, TypedTables

data = Table(X=t, Y=obs)

ols = lm(@formula(Y ~ X), data)

lines!(t, predict(ols), color=(:red, 0.7), linewidth=3)
fig




fig = Figure(resolution=(1280, 720))

ax1 = Axis(fig[1, 1], title="Makie")
fig


K = Int(round(1 + 3.322log(length(obs))))

hist1 = hist!(ax1, obs, color=(:dodgerblue, 0.5), strokecolor=(:black, 1), bins=K)
fig

