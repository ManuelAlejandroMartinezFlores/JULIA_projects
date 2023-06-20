# Implement number base conversion


function all_your_base(digits, base_in, base_out)
    base_in > 1 || throw(DomainError(" "))
    base_out > 1 || throw(DomainError(" "))
    length(digits) == 0 && return [0]
    
    sum(0 .<= digits .< base_in) == length(digits) || throw(DomainError(" "))
    
    number = 0 
    for (n, d) in enumerate(reverse(digits))
        n -= 1 
        number += d * base_in ^ n 
    end 
    number

    number == 0 && return [0]

    m = round(Int, floor(log(number) / log(base_out)))
    res = []
    for n in m:-1:0
        if base_out ^ n > number 
            push!(res, 0)
        else 
            d = round(Int, floor(number / base_out^n))
            number -= d * base_out^n
            push!(res, d)
        end
    end 
    res
end


all_your_base([1, 0, 1], 2, 3)