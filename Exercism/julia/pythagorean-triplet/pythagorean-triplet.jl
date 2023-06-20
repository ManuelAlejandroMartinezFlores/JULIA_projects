# Define the pythagorean_triplets(N) function


function pythagorean_triplets(N)
    N % 2 == 0 || return []
    res = []
    for a in 1:N 
        for b in a:N 
            c = sqrt(a^2 + b^2)
            c - round(c) ≈ 0 || continue    
            c = round(c)
            a + b + c == N || continue 
            push!(res, (a, b, c))
        end 
    end 
    res

end