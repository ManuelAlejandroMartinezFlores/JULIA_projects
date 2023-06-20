response = Dict(
        :question => "Sure.",
        :yelling => "Whoa, chill out!",
        :silence => "Fine. Be that way!",
        :misc => "Whatever.",
        :forceful_question => "Calm down, I know what I'm doing!",
)


function bob(stimulus)
    s = replace(stimulus, r"[^\w?]" => "")
    length(s) == 0 && return response[:silence]
    allupper = []
    for c in s 
        c == '?' && continue
        isdigit(c) && continue
        push!(allupper, isuppercase(c))
    end 
    allupper = length(allupper) > 0 && sum(allupper) == length(allupper)
    if s[end] == '?'
        allupper && return response[:forceful_question]
        return response[:question]
    end 
    allupper && return response[:yelling]
    return response[:misc]
end
