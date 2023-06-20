abc = "abcdefghijklmnopqrstuvwxyz"

function encode(input)
    input = lowercase(input)
    input = replace(input, r"[^\w\d]" => "")
    cnt = 1
    res = ""
    for c in input 
        try
            id = length(abc) + 1 .- findfirst(string(c), abc)
            new = string(abc[id])
        catch 
            new = string(c)
        end
        if cnt == 5
            new *= " "
            cnt = 0
        end 
        res *= new
        cnt += 1
    end 
    replace(res, r"\s$" => "")  
end

function decode(input)
    input = replace(input, " " => "")
    res = ""
    for c in input 
        new = ""
        try
            id = length(abc) + 1 .- findfirst(string(c), abc)
            new = string(abc[id])
        catch 
            new = string(c)
        end
        res *= new 
    end 
    res
end

