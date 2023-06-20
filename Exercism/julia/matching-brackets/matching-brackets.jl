

PAIRS = Dict(
    ']' => '[', 
    '}' => '{',
    ')' => '(',
)


t = "{x[a]}"
t = replace(t, r"[^{}()\[\]]" => "")

l = []

for c in t 
    push!(l, c)
end 


function matching_brackets(s::String)
    s = replace(s, r"[^{}()\[\]]" => "")
    l = []
    for c in s 
        if c in keys(PAIRS)
            try
                PAIRS[c] == pop!(l) || return false 
            catch 
                return false 
            end
        else 
            push!(l, c)
        end 
    end 
    length(l) == 0

end



matching_brackets("\\left(\\begin{array}{cc} \\frac{1}{3} & x\\\\ \\mathrm{e}^{x} &... x^2 \\end{array}\\right)")