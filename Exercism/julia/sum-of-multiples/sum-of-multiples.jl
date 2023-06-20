function sum_of_multiples(limit, factors)
    s = [[n * fact for n in 1:limit if n*fact < limit] for fact in factors]
    length(s) == 0 && return 0
    sum(union(s...))  
end
