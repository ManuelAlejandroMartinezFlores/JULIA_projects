using CSV, DataFrames

df = DataFrame(CSV.File("pop_year.csv"))

regions = propertynames(df)[2:end]

using GLMakie

Makie.inline!(false)

fig = Figure(resolution=(1080, 720))

ax1 = Axis(fig[1, 1], 
    title = "population",
    titlegap = 20, titlesize=30,
    xticks = LinearTicks(10), yticks = LinearTicks(10),
    xlabel = "year", ylabel="population millions"
)

frames = 1:(length(df.Year))

using Colors

colors = distinguishable_colors(7, [RGB(1,1,1), RGB(0,0,0)], dropseed=true);


ll = []

for t in zip(colors, regions)
    c, r = t
    push!(ll, lines!(ax1, [df.Year[1]], [df.World[1]], color=c, label=string(r)))
end

axislegend("region")

record(fig, "pop_region.mp4", frames; framerate=12) do i 
    for j in 1:length(regions)
        lines!(ax1, df.Year[1:i], df[1:i, regions[j]], color=colors[j], label = string(regions[j]))
    end 
    
end 
    

########################################################
# MonteCarlo
########################################################

function montecarlo()
fig = Figure(resolution=(1080, 720))

ax1 = Axis(fig[1, 1], aspect = AxisAspect(1),
    title = "MonteCarlo", limits = (-1, 1, -1, 1),
    titlegap = 20, titlesize=30,
    xticks = LinearTicks(2), yticks = LinearTicks(2),
    xautolimitmargin = (0, 0), yautolimitmargin = (0, 0)
)


ax2 = Axis(fig[1, 2], title = L"\pi", aspect = AxisAspect(1), limits = (nothing, nothing, 2.5, 4),
    titlegap = 20, titlesize=30, 
    xticks = LinearTicks(5), yticks = LinearTicks(5),
    xautolimitmargin = (0, 0), yautolimitmargin = (0, 0)
)

hlines!(ax2, pi, color=:darkgrey, linestyle=:dash)

n = 30 * 10 * 200

x = rand(n) .* 2 .- 1;
y = rand(n) .* 2 .- 1;
incircle = sqrt.(x.^2 + y.^2) .< 1

piest = 4 .* cumsum(incircle) ./ (1:n)

colors = [:red for i in 1:n]
colors[Bool.(incircle)] .= :green 

frames = 1:(30 * 10)

record(fig, "pi_est.mp4", frames; framerate=30) do i 
    stop = i * 200; start = stop - 199; range = start:stop
    scatter!(ax1, x[range], y[range], color=colors[range], markersize=1)

    lines!(ax2, [start, stop], piest[[start, stop]], color=:dodgerblue)
end


## 
fig
end 


montecarlo()