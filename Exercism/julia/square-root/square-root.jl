function square_root(n)
    n > 0 || throw(DomainError(" "))
    lb, ub = 0, n
    tol = 0.1
    m = (lb + ub) / 2 

    m2 = m*m
    while abs(m2 - n) > tol
        if m2 > n 
            ub = m 
        else 
            lb = m
        end 
        m = (lb + ub) / 2 
        m2 = m * m
    end
    round(m)
end
