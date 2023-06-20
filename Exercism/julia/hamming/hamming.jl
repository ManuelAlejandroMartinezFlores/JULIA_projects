"Your optional docstring here"
function distance(a, b)
    length(a) == length(b) || throw(ArgumentError(" "))
    dist = 0
    for (x, y) in zip(a, b)
        if x != y 
            dist += 1
        end 
    end 
    dist

end
