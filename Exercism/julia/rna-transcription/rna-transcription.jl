
D = Dict("G" => "C", "C" => "G", "T" => "A", "A" => "U")

function to_rna(dna)
    res = ""
    for n in dna 
        try 
            res *= D[string(n)]
        catch
            throw(ErrorException(" "))
        end
    end 
    res
end

