function detect_anagrams(subject, candidates)
    subject = lowercase(subject)
    D = Dict()
    for c in subject
        if c in keys(D)
            D[c] += 1 
        else 
            D[c] = 1 
        end 
    end 
    ans = []
    for w in candidates 
        wc = lowercase(w)
        flag = false
        d = copy(D)
        for c in wc 
            try 
                d[c] -= 1 
            catch
                flag = true
            end 
        end 
        flag && continue
        flag = true
        for k in keys(d)
            flag = flag && d[k] == 0 
        end 
        if flag && wc != subject
            push!(ans, w)
        end
    end
    ans
end
