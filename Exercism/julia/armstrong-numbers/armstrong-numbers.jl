function isarmstrong(n)
    D = digits(n)
    m = length(D)
    res = 0
    for d in D
        res += d ^ m 
    end 
    res == n 
end