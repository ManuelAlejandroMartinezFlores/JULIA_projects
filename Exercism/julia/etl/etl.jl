function transform(input::AbstractDict)
    D = Dict()
    for n in keys(input)
        for letter in input[n]
            D[lowercase(letter)] = n 
        end 
    end 
    D
end

