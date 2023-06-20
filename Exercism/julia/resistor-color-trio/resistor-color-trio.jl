D = Dict("black" => 0,
"brown" => 1,
"red" => 2,
"orange" => 3,
"yellow" => 4,
"green" => 5,
"blue" => 6,
"violet" => 7,
"grey" => 8,
"white" => 9)


function label(colors)
    n = D[colors[1]] * 10 + D[colors[2]]
    res = ""
    n *= round(exp10(D[colors[3]]))
    if n % 1000 == 0
        res = "kilo"
        n /= 1000
    end 
    n = round(Int, n)
    "$n $(res)ohms"
end
