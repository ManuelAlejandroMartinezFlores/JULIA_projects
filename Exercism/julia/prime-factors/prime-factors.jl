function prime_factors(n)
    res = []
    N = n
    d = 2
    while d <= n
        while n % d == 0
            push!(res, d)
            n = round(n / d)
        end
        d += 1
    end
    res
end