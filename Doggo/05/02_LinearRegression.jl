using CSV, GLM, TypedTables, Plots 


data = CSV.File("housing.csv")

X = (data.size .- 1000) ./ 3000 
Y = (data.price ./ 6e5)
table = Table(X=X, Y=Y)


scatter(X, Y, color=:teal, label="data")


ols = lm(@formula(Y~X), table)

plot!(X, predict(ols), color=:tomato, label="fit", linewidth=3)



####################################################
####################################################

m = 0.; b = 0.

scatter(X, Y, color=:teal, label="data")

f(b, m) = b .+ m .* X 


using Statistics

cost(X, Y) = mean((f(X) - Y) .^ 2)

step(b, m, lr=0.5)= b - lr * mean(f(b, m) - Y), m - lr * mean((f(b, m) - Y) .* X)


using Colors

col = range(HSL(colorant"red"), HSL(colorant"green"), length=5);

for e in 1:5
    for i in 1:5
        b, m = step(b, m)
    end 
    plot!(X, f(b, m), color=col[e], label="epoch $e")
    println("$e, $b, $m")
end 
plot!(0, 0)