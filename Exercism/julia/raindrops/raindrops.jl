function raindrops(number)
    s = ""
    if number % 3 == 0
        s *= "Pling"
    end
    if number % 5 == 0
        s *= "Plang"
    end
    if number % 7 == 0
        s *= "Plong"
    end 
    length(s) == 0 ? (return string(number)) : (return s)
end
