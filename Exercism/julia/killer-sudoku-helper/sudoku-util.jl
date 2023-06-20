function combinations_in_cage(n, m, res=[])
if m == 1
    n in res || (0 < n < 10 && return [[n]])
    return []
end
ans = []
for x in 1:9
    if !(x in res)
        c = combinations_in_cage(n - x, m-1, [res..., x])
        length(c) == 0 && continue
        for l in c 
            push!(ans, sort([l..., x]))
        end
    end
end 
unique(ans)
end