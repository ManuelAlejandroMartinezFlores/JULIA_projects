"""
    ispangram(input)

Return `true` if `input` contains every alphabetic character (case insensitive).

"""
function ispangram(input)
    abc = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    for x in abc 
        x in uppercase(input) || return false 
    end 
    return true
end

