using GLMakie

Makie.inline!(false)


using Observables


x = Observable(1.)

y = Observable(2.)

z = @lift($x .+ $y)

x[] = 10.

z



####################################################
# Sliders
####################################################

fig = Figure(resolution = (1080, 720))

ax1 = Axis(fig[1, 1], 
    aspect = 1, 
    title = "slider",
    titlesize = 30
)

vlines!(ax1, [0], linewidth=2, color=:black)
hlines!(ax1, [0], linewidth=2, color=:black)

slgrid = SliderGrid(fig[2, 1], height=30,
    (label = "slope", range = -10:0.1:10, startvalue = 0, format = "{:.1f}"),
    (label = "intercept", range = -10:0.1:10, startvalue = 0, format = "{:.1f}"),
)


slope = slgrid.sliders[1].value
inter = slgrid.sliders[2].value

x = collect(-10:0.1:10)

y = @lift($slope .* x .+ $inter)

line1 = lines!(ax1, x, y, color = :tomato, linewidth=3)

xlims!(-10, 10); ylims!(-10, 10)



####################################################
# Button
####################################################

fig = Figure(resolution = (1080, 720))

ax1 = Axis(fig[1, 1], 
    aspect = 1, 
    title = "button",
    titlesize = 30,
    xticks = LinearTicks(10),
    yticks = LinearTicks(10)
)

vlines!(ax1, [0], linewidth=2, color=:black)
hlines!(ax1, [0], linewidth=2, color=:black)

labels = ["tomato", "teal"]

butlay = fig[2, 1] = GridLayout(tellwidth=false)

buttons = butlay[1, 1:2] = [Button(
    fig, label=l,
    height = 40, width = 200
) for l in labels]

x = collect(-10:0.1:10)

using Random

data = [shuffle(x) for _ in 1:2]
colors = [:tomato, :teal]

i =  Observable(2) 
y = @lift(data[$i])
c = @lift((colors[$i], 0.5))

scatter!(ax1, x, y, color=c)


for j = 1:2
    on(buttons[j].clicks) do click 
        i[] = j
    end 
end


####################################################
# Menu
####################################################

fig = Figure(resolution = (1080, 720))

ax1 = Axis(fig[1, 1], 
    aspect = 1, 
    title = "menu",
    titlesize = 30,
    xticks = LinearTicks(10),
    yticks = LinearTicks(10)
)

x = collect(-10:0.1:10)

using Random

data = [shuffle(x) for _ in 1:2]
labels = ["tomato", "teal"]
colors = [:tomato, :teal]

datamenu = Menu(fig, options = [1, 2])
colormenu = Menu(fig, options = colors)

fig[2, 1] = hgrid!(
    Label(fig, "data"), datamenu,
    Label(fig, "color"), colormenu
)

y = Observable(data[1])
c = Observable(colors[1])

on(datamenu.selection) do select 
    y[] = data[select]
end 

on(colormenu.selection) do select
    c[] = select
end

scatter!(ax1, x, y, color=c)

