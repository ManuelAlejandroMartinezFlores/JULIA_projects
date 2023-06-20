mutable struct Robot
    name::String
end

const names = Set([""])

Robot() = begin
    r = reset!(Robot(""))
    push!(names, name(r))
    r 
end


abc = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
dig = "0123456789"

function reset!(instance::Robot)
    n = ""
    while n in names
        n = rand(abc) * rand(abc) * rand(dig) * rand(dig) * rand(dig)
    end 
    instance.name = n
    instance
end

function name(instance::Robot)
    instance.name
end
