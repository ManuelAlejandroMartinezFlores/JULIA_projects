using QuadGK

f(x) = sqrt(x)


area, error = quadgk(f, 0, 1)


using Plots

x = 0:0.01:2
inter = 0.5:0.01:1.5

plot(inter, f, fillrange=0, fillcolor=:teal, fillalpha=0.2, legend=false)
plot!(x, f, linewidth=3, color=:black, legend=false)

volume, vol_error = quadgk(x -> pi * f(x)^2, 0, 1)

THETA = range(0, 2pi, 360)


circle(x, r) = fill(x, 360), r * cos.(THETA), r * sin.(THETA)


p = plot([0, 2], [0, 0], [0, 0], color=:black, label=false)
for x in range(0, 2, 20)
    plot!(circle(x, f(x)), color=:teal, label=false)
end
p


