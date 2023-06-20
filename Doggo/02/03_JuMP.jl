using JuMP
using GLPK

model = Model(GLPK.Optimizer)

@variable model (x >= 0)
@variable model (y >= 0)

@constraint model (6x + 8y >= 100)
@constraint model (7x + 12y >= 120)

@objective model Min (12x + 20y)

optimize!(model)

@show value(x)
@show value(y)

using Ipopt

model = Model(Ipopt.Optimizer)

@variable model (x >= 0) start=0
@variable model (y >= 0) start=0 

@NLconstraint model (x + 2y == 100)

@NLobjective model Max (x*y)

optimize!(model)

@show value(x)
@show value(y)

using Plots

plotlyjs(size=(760, 570))
x = 0:100
area(x) = x * (100 - x) / 2

p = plot(x, area, title="Maximize area")
