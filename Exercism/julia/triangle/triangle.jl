function is_equilateral(sides)
    valid(sides) && length(unique(sides)) == 1
end

function is_isosceles(sides)
    valid(sides) && length(unique(sides)) < 3
end

function is_scalene(sides)
    valid(sides) && length(unique(sides)) == 3
end

function valid(sides)
    sides[1] + sides[2] >= sides[3] && 
    sides[1] + sides[3] >= sides[2] && 
    sides[2] + sides[3] >= sides[1] && sum(sides) > 0
end



@show valid([4, 4, 4])
