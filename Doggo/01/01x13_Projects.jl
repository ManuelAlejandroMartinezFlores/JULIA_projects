using Makie 

using CairoMakie

using Colors

function walker(n::Integer)
    x = [0]
    y = [0]

    for _ in 1:n
        step = rand((-1, 1))
        dir = rand(Bool)
        if dir
            push!(x, x[end] + step)
            push!(y, y[end])
        else 
            push!(x, x[end])
            push!(y, y[end]+ step)
        end
    end 
    x, y 
end


function plotwalker(walkers::Integer, steps::Integer)
    f = Figure()
    ax = Axis(f[1, 1])
    for color in distinguishable_colors(walkers)
        x, y = walker(steps)
        lines!(ax, x, y, linewidth=2, color = (color, 0.5))
    end 
    f
end 


function plotwalker_simd(walkers::Integer, steps::Integer)
    f = Figure()
    ax = Axis(f[1, 1])
    @simd for color in distinguishable_colors(walkers)
        x, y = walker(steps)
        lines!(ax, x, y, linewidth=2, color = (color, 0.5))
    end 
    f
end 
