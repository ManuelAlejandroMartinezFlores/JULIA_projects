sigmoid(x) = 1 ./ (1 .+ exp.(-x))

X = rand(100);

Y = (X .+ rand(100) .* 0.4 .- 0.2) .> 0.5;


using Plots 


scatter(X, Y, label="data", color=:teal, alpha=0.6)



m = 0.; b =0.

f(b, m, X) = sigmoid(b .+ m .* X)

using Statistics

step(b, m, lr=0.1)= b - lr * mean(f(b, m, X) - Y), m - lr * mean((f(b, m, X) - Y) .* X)


using Colors

col = range(HSL(colorant"red"), HSL(colorant"green"), length=10);

t = 0:0.01:1

for e in 1:10
    for i in 1:500
        b, m = step(b, m)
    end 
    plot!(t, f(b, m, t), color=col[e], label="epoch $e")
    println("$e, $b, $m")
end 
plot!(0, 0)