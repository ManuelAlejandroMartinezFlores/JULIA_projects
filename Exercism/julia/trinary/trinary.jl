function trinary_to_decimal(str)
    res = 0 
    for (n, d) in enumerate(reverse(str))
        try 
            d = parse(Int, d)
            0 <= d <= 3 || return false
        catch 
            return false
        end 
        res += d * 3^(n-1)
    end 
    res
end
