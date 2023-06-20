using Images

using BenchmarkTools


x0, y0 = 0., 0.

function iteration(c; max_iter=1024)
    z = c 
    for n in 1:max_iter
        if abs(z) > 2
            return n - log2(max(abs(z), 1.))
        end 
        z = z^2 + c
    end 
    return 0
end


function coloring(n)
    if n == 0
        return RGB(0, 0, 0)
    end
    RGB(0.5sin(0.1n) + 0.5, 
        0.5sin(0.1n + 1.5) + 0.5, 
        0.5sin(0.1n + 2) + 0.5)
end

function show_cpu(x0=0, y0=0, zoom=0; max_iter=1024, height=720, width=720)
    R = 1.5 * exp(-zoom)
    x = range(x0 - R, x0 + R, width)
    y = range(y0 - R, y0 + R, height) .* im

    z = zeros(RGB{Float64}, width, height); 

    Threads.@threads for j in eachindex(y) 
        @simd for i in eachindex(x)
            @inbounds z[i, j] = coloring(iteration(x[i] + y[j]; max_iter=max_iter))
        end 
    end 
    z' 
end


show_cpu(-0.5, 0, 0)
show_cpu(0.066, -0.63, 7)




@btime show_cpu(0.066, -0.63, 7)


using GLMakie

Makie.inline!(false)



function infinite_zoom(x0=0.066, y0=-0.63; max_iter=1024, height=720, vel=1)
    x0 = Observable(x0); y0 = Observable(y0); zoom = Observable(0.)
    control_zoom = Observable(0.)

    mm = Observable(show_cpu(x0[], y0[], (zoom[] + 0.5 / vel) * vel; max_iter=max_iter, height=height, width=height)')

    m = Observable(show_cpu(x0[], y0[], zoom[]; max_iter=max_iter, height=height, width=height)')

    R = @lift(1.5exp(- $zoom * vel))
    Rm = @lift(round(Int, (1 - exp(vel * ($zoom - $control_zoom * 0.005))) * height / 2))

    fig = Figure(size=(height, height))
    ax = GLMakie.Axis(fig[1, 1])
    image!(ax, m)
    xlims!(Rm[], height - Rm[])
    ylims!(Rm[], height - Rm[])
    GLMakie.hidedecorations!(ax)

    function update_zoom()
        # zoom[] += 0.5 / vel
        mm[] =show_cpu(x0[], y0[], (zoom[] + 0.5 / vel) * vel; max_iter=max_iter, height=height, width=height)'
        println("done")
    end 

    on(events(fig).mousebutton) do event 
        if event.button == Mouse.left
            if event.action == Mouse.press 
                px0, py0 = (events(fig).mouseposition[] ./ height .* 2 .- 1.) .* R[] .+ (x0[], y0[])
                println([px0, py0])
                x0[] = px0; y0[] = py0
                m[] = show_cpu(x0[], y0[], zoom[] * vel; max_iter=max_iter, height=height, width=height)'
                zt = @task update_zoom()
                schedule(zt)
            end
        end
    end

    

    on(events(fig).keyboardbutton) do event 
        if (event.action == Keyboard.press || event.action == Keyboard.repeat) && event.key == Keyboard.space
            control_zoom[] += 1 
            xlims!(Rm[], height - Rm[])
            ylims!(Rm[], height - Rm[])
            when = round(Int, 100 / vel)
            if control_zoom[] % when == 0
                m[] = mm[]
                xlims!(0, height)
                ylims!(0, height)
                zoom[] += 0.5 / vel
                control_zoom[] = round(Int, zoom[] / 0.005)
                zt = @task update_zoom()
                schedule(zt)
            end
            println(control_zoom[] * 0.005, "\t", zoom[], "\t", Rm[])
        end
    end
    fig
end

infinite_zoom(;vel=3, height=720)