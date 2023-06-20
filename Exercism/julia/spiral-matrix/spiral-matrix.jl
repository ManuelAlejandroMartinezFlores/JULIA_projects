function spiral_matrix(n)
    n == 0 && return Matrix{Int}(undef, 0, 0)
    h = n % 2 == 0 ? round(n/2) : round((n+1)/2)
    id = [1, 0]
    cnt = 0 
    H = true
    M = Matrix{Int}(undef, n, n)
    fill!(M, 0)
    while cnt < n*n 
        #M[id...] = cnt 
        step = [0, 1]  
        if H 
            if id[1] > h 
                step = [0, -1]
            end 
        else 
            if id[2] >= h 
                step = [1, 0]
            else 
                step = [-1, 0]
            end 
        end
        try 
            tid = step .+ id 
            tcnt = 1 + cnt
            @assert M[tid...] == 0 
            M[tid...] = tcnt
            id = tid 
            cnt = tcnt
        catch 
            H = !H
        end
    end
    M
end
