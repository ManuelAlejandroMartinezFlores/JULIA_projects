function encode(s)
    current = ""
    code = ""
    cnt = 0
    for c in s
        if c == current 
            cnt += 1
        else 
            n = cnt <= 1 ? "" : string(cnt)
            code *= n * string(current)
            current = c 
            cnt = 1
        end
    end 
    n = cnt <= 1 ? "" : string(cnt)
    code *= n * string(current)
    code
end



function decode(s)
    res = ""
    current = ""
    for c in s
        if isnumeric(c)
            current *= string(c)
        else 
            n = length(current) == 0 ? 1 : parse(Int, current)
            res *= string(c)^n
            current = ""
        end
    end
    res
end
