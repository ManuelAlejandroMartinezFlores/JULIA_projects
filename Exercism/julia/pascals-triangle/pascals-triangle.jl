fact(n) = n < 2 ? 1 : n * fact(n-1)
choose(k, n) = round(Int, fact(n) / (fact(k) * fact(n - k)))



function triangle(n)
    n < 0 && throw(DomainError(" "))
    [[choose(k, m) for k in 0:m] for m in 0:(n-1)]
end
