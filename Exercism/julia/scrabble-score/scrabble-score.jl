s1 = ["A", "E", "I", "O", "U", "L", "N", "R", "S", "T"]
s2 = ["D", "G"]
s3 = ["B", "C", "M", "P"]
s4 = ["F", "H", "V", "W", "Y"]
D = Dict("K" => 5, "J" => 8, "X" => 8, "Q" => 10, "Z" => 10)
for s in s1 
    D[s] = 1 
end 
for s in s2 
    D[s] = 2
end 
for s in s3
    D[s] = 3 
end 
for s in s4 
    D[s] = 4 
end

function score(str)
    sc = 0
    str = uppercase(str)
    for c in str 
        try
            sc += D[string(c)]
        catch 
        end
    end 
    sc
end
