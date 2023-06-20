D = ("I" => 1, "V" => 5, "X" => 10, "L" => 50, "C" => 100, "D" => 500, "M" => 1000 )
LIT = ["M", "D", "C", "L", "X", "V", "I"]
VAL = [1000, 500, 100, 50, 10, 5, 1]
PREV = [false, false, true, false, true, false, true]

function to_roman(number)
    number > 0 || throw(ErrorException(" "))
    res = ""
    i = 1 
    while i < 8
        k, v = LIT[i], VAL[i]
        if v > number 
            j = findnext(PREV, i+1)
            if !(j === nothing)
                if v - number <= VAL[j]
                    res *= LIT[j] * k
                    number -= v - VAL[j]
                end
            end
            i += 1 
        end

        d = round(Int, floor(number / v))
        if d < 4     
            res *= k^d 
        end
        number -= d * v
    end 
    res
end

