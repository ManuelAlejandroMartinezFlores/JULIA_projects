function acronym(phrase)
    phrase = lowercase(phrase)
    phrase = replace(phrase, r"[^a-z']" => " ")
    res = ""
    for w in split(phrase)
        length(w) == 0 && continue 
        res *= uppercase(w[1])
    end
    res
end
