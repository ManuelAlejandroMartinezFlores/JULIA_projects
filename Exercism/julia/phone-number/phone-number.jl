function clean(phone_number)
    n = replace(phone_number, r"\D" => "")
    if length(n) == 11 
        parse(Int, n[1]) == 1 || throw(ArgumentError(" "))
        n = n[2:end]
    end
    length(n) == 10 || throw(ArgumentError(" "))
    parse(Int, n[1]) < 2 && throw(ArgumentError(" "))
    parse(Int, n[4]) < 2 && throw(ArgumentError(" "))
    n
end
