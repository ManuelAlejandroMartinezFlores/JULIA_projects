function wordcount(sentence)
    sentence = lowercase(sentence)
    ss = replace(sentence, r"[^a-z'0-9]" => " ")
    @show ss
    s = split(ss, " ")
    D = Dict()
    for x in s 
        x == "" && continue
        x == "\'" && continue
        if x[end] == '\'' && x[1] == '\'' 
            x = x[2:end-1]
        end
        if x in keys(D)
            D[x] += 1
        else 
            D[x] = 1
        end 
    end
    D
end
