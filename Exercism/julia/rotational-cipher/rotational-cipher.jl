abc = "abcdefghijklmnopqrstuvwxyz"


function rot(n, x)
    if lowercase(x) in abc
        up = isuppercase(x)
        x = lowercase(x)
        id = (findfirst(x, abc) + n) % 26
        id = id == 0 ? 26 : id
        up ? (return uppercase(abc[id])) : (return abc[id])
    else 
        return x 
    end
end

function rotate(n, s)
    ch = isa(s, Char)
    new = [rot(n, x) for x in s]
    ch ? (return new[1]) : return String(new)
end

for n in 1:26 
    s = Symbol("R", n, "_str")
    @eval macro $s(x); rotate($n, x); end 
end

@show R13"abc"

