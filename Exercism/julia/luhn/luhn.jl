function luhn(s)
    s = replace(s, r"\s" => "")
    match(r"\D", s) === nothing || return false 
    length(s) > 1 || return false
    res = 0
    for (n, d) in enumerate(s)
        d = parse(Int, d)
        if n % 2 != length(s) % 2 
            res += 2d > 9 ? 2d - 9 : 2d 
        else 
            res += d
        end
    end 
    res % 10 == 0
end