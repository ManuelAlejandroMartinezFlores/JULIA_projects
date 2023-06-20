function sieve(limit)
    l = [false, [true for _ in 2:limit]...]
    idx = 2 
    while !(idx === nothing) && 2idx <= limit
        @show idx
        l[2idx:idx:limit] .= false 
        idx = findnext(l, idx+1)  
    end 
    [n for (n, x) in enumerate(l) if x]
end
