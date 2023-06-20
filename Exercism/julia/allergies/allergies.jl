D = Dict("eggs" => 1, "peanuts" => 2, "shellfish" => 3, 
    "strawberries" => 4, "tomatoes" => 5, "chocolate" => 6, 
    "pollen" => 7, "cats" => 8
)



function allergic_to(score, allergen)
    d = digits(score, base=2)
    idx = D[allergen]
    length(d) >= idx && d[idx] == 1
end

function allergy_list(score)
    l = []
    for al in keys(D)
        if allergic_to(score, al)
            push!(l, al)
        end 
    end 
    Set(l)
end
