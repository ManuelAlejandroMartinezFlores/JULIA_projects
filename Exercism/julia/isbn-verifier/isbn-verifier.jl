function p(d) 
    try 
        return parse(Int, d)
    catch 
        return 10 
    end 
end

struct ISBN
    s::String 
    f::Bool
end

function ISBN(str::String)
    match(r"[^\dX-]", str) === nothing || throw(DomainError(" "))
    str = replace(str, r"[^\dX]" => "")
    length(str) == 10 || throw(DomainError(" "))
    match(r"X", str[1:9]) === nothing || throw(DomainError(" "))

    val = [p(d) for d in str] .* (10:-1:1)
    sum(val) % 11 == 0 || throw(DomainError(" "))
    ISBN(str, true)
end


macro ISBN_str(s)
    :(ISBN($s))
end 

@show ISBN"3-598-21508-8"