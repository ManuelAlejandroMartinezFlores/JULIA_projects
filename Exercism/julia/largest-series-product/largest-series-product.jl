function largest_product(str, span)
    s = replace(str, r"\D" => "")
    length(s) == length(str) || throw(ArgumentError(" "))
    s = parse.(Int, split(s, ""))
    span > length(s) && throw(ArgumentError(" "))
    span < 0 && throw(ArgumentError(" "))

    m = -999
    for i in 1:(length(s) - span + 1) 
        p = prod(s[i:(i+span-1)])
        @show p 
        if p > m 
            m = p 
        end 
    end
    m 
end
