1+1


include("01x08_functions.jl")

myforloop(2)


using Pkg 
Pkg.add("OhMyREPL")

# Package REPL "]"

using OhMyREPL


using BenchmarkTools

@benchmark myforloop(10000000)

using Random

r2 = randn(100000);

sum(r2) / 100000

randstring(10)


vec = [1:10;]
shuffle(vec);
vec 
shuffle!(vec); 
vec

using Statistics 

mean(r2)
median(r2)

########################
########################



using Makie

Makie.inline!(true) #true = vscode, false = glmakie 

using GLMakie

GLMakie.activate!()

y = rand(10);

scene = lines(y)

scene = lines(y, color=:red )

scene = lines(y, color=:red, linewidth=10)
display(scene)

save("plot.jpg", scene)

##################

x = -10:0.01:10;

scene = lines(x, x.^2, color=:blue)


x = rand(100);
y = rand(100);
z = rand(100);

scene = scatter(y, color=:green)
scene = scatter(x, y, color=:green)
scene = scatter(x, y, z, color=:green)


x = -10:0.01:10;
x2 = -10:10
scene = lines(x, x.^2, color=:blue)
scene = scatter!(x2, x2.^2, color=:red)
display(f)


y = rand(10);
scene = barplot(y, color=:tomato)

grid = rand(10, 10);
scene = heatmap(grid, colormap=:heat)
scene.axis.xlabel = "x"
scene.axis.title = "title"
display(scene)



