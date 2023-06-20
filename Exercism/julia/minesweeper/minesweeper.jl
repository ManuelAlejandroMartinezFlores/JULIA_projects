function annotate(minefield)
    length(minefield) == 0 && return []
    m, n = length(minefield), length(minefield[1])
    out = copy(minefield)
    out = split.(out, "")
    @show out
    for i in 1:m
        for j in 1:n 
            sub = minefield[i][j]
            sub == '*' && continue 
            cnt = 0
            for s in -1:1, t in -1:1
                try 
                    c = minefield[i+s][j+t] == '*' ? 1 : 0
                    cnt += c
                catch
                end
            end
            out[i][j] = cnt == 0 ? " " : string(cnt)
        end
    end
    [join(c) for c in out]
end