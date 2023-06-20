include("permutations.jl")
 

function get_coeffs(w, D)
    for (n, c) in enumerate(reverse(w))
        n -= 1 
        if c in keys(D)
            D[c] += 10^n 
        else 
            D[c] = 10^n 
        end 
    end     
end

function get_exp(s)
    op, ans = split(s, "==")
    op = split(op, "+")
    D = Dict()
    (x -> get_coeffs(x, D)).(op)
    initial = [w[1] for w in op]
    res = "0"
    u = keys(D)
    for c in keys(D)
        res *= " + " * string(D[c]) * c  
    end
    res *= "== 0"
    D = Dict()
    get_coeffs(ans, D)
    for c in keys(D)
        res *= " + " * string(D[c]) * c  
    end
    push!(initial, ans[1])
    ini = "false"
    for c in unique(initial)
        ini *= "||" * c * "==0"
    end 
    u = unique([u..., keys(D)...])

    r = "equality("
    for c in u
        r *= c * ","
    end 
    res = r[1:end-1] * ")=" * res 

    r = "initial("
    for c in u
        r *= c * ","
    end 
    ini = r[1:end-1] * ")=" * ini 
    Meta.parse(res), Meta.parse(ini), u 
end


function solve(s)
    s = replace(s, " " => "")
    eq, init, u = get_exp(s)
    eval(eq)
    eval(init)

    vec = collect(0:9)

    for p in permutations(vec, length(u))
        Base.invokelatest(initial, p...) && continue
        if Base.invokelatest(equality, p...)
            return Dict(x => v for (x, v) in zip(u, p))
        end 
    end
    nothing
end



# function solve(s)
#     op, ans = split(s, " == ")
#     op = split(op, " + ")
#     u = unique(replace(s, r"\W" => ""))

#     initial = unique([[w[1] for w in op]..., ans[1]])

#     vec = collect(0:9)

#     D = Dict(String([c]) => i for (i, c) in enumerate(u))

#     for p in permutations(string.(vec), length(u))
#         any(parse.(Int, map(x -> p[D[string(x)]], initial)) .== 0) && continue 
#         ops = parse.(Int, [join(replace(x -> p[D[x]], split(o, "")), "") for o in op])
#         anss = parse(Int, join(replace(x -> p[D[x]], split(ans, "")), ""))
#         if sum(ops) == anss 
#             return Dict(x => parse(Int, p[D[string(x)]]) for x in u)
#         end 
#     end
#     nothing
# end



# @time solve("THIS + A + FIRE + THEREFORE + FOR + ALL + HISTORIES + I + TELL + A + TALE + THAT + FALSIFIES + ITS + TITLE + TIS + A + LIE + THE + TALE + OF + THE + LAST + FIRE + HORSES + LATE + AFTER + THE + FIRST + FATHERS + FORESEE + THE + HORRORS + THE + LAST + FREE + TROLL + TERRIFIES + THE + HORSES + OF + FIRE + THE + TROLL + RESTS + AT + THE + HOLE + OF + LOSSES + IT + IS + THERE + THAT + SHE + STORES + ROLES + OF + LEATHERS + AFTER + SHE + SATISFIES + HER + HATE + OFF + THOSE + FEARS + A + TASTE + RISES + AS + SHE + HEARS + THE + LEAST + FAR + HORSE + THOSE + FAST + HORSES + THAT + FIRST + HEAR + THE + TROLL + FLEE + OFF + TO + THE + FOREST + THE + HORSES + THAT + ALERTS + RAISE + THE + STARES + OF + THE + OTHERS + AS + THE + TROLL + ASSAILS + AT + THE + TOTAL + SHIFT + HER + TEETH + TEAR + HOOF + OFF + TORSO + AS + THE + LAST + HORSE + FORFEITS + ITS + LIFE + THE + FIRST + FATHERS + HEAR + OF + THE + HORRORS + THEIR + FEARS + THAT + THE + FIRES + FOR + THEIR + FEASTS + ARREST + AS + THE + FIRST + FATHERS + RESETTLE + THE + LAST + OF + THE + FIRE + HORSES + THE + LAST + TROLL + HARASSES + THE + FOREST + HEART + FREE + AT + LAST + OF + THE + LAST + TROLL + ALL + OFFER + THEIR + FIRE + HEAT + TO + THE + ASSISTERS + FAR + OFF + THE + TROLL + FASTS + ITS + LIFE + SHORTER + AS + STARS + RISE + THE + HORSES + REST + SAFE + AFTER + ALL + SHARE + HOT + FISH + AS + THEIR + AFFILIATES + TAILOR + A + ROOFS + FOR + THEIR + SAFE == FORTRESSES")
# @time solve_meta("THIS + A + FIRE + THEREFORE + FOR + ALL + HISTORIES + I + TELL + A + TALE + THAT + FALSIFIES + ITS + TITLE + TIS + A + LIE + THE + TALE + OF + THE + LAST + FIRE + HORSES + LATE + AFTER + THE + FIRST + FATHERS + FORESEE + THE + HORRORS + THE + LAST + FREE + TROLL + TERRIFIES + THE + HORSES + OF + FIRE + THE + TROLL + RESTS + AT + THE + HOLE + OF + LOSSES + IT + IS + THERE + THAT + SHE + STORES + ROLES + OF + LEATHERS + AFTER + SHE + SATISFIES + HER + HATE + OFF + THOSE + FEARS + A + TASTE + RISES + AS + SHE + HEARS + THE + LEAST + FAR + HORSE + THOSE + FAST + HORSES + THAT + FIRST + HEAR + THE + TROLL + FLEE + OFF + TO + THE + FOREST + THE + HORSES + THAT + ALERTS + RAISE + THE + STARES + OF + THE + OTHERS + AS + THE + TROLL + ASSAILS + AT + THE + TOTAL + SHIFT + HER + TEETH + TEAR + HOOF + OFF + TORSO + AS + THE + LAST + HORSE + FORFEITS + ITS + LIFE + THE + FIRST + FATHERS + HEAR + OF + THE + HORRORS + THEIR + FEARS + THAT + THE + FIRES + FOR + THEIR + FEASTS + ARREST + AS + THE + FIRST + FATHERS + RESETTLE + THE + LAST + OF + THE + FIRE + HORSES + THE + LAST + TROLL + HARASSES + THE + FOREST + HEART + FREE + AT + LAST + OF + THE + LAST + TROLL + ALL + OFFER + THEIR + FIRE + HEAT + TO + THE + ASSISTERS + FAR + OFF + THE + TROLL + FASTS + ITS + LIFE + SHORTER + AS + STARS + RISE + THE + HORSES + REST + SAFE + AFTER + ALL + SHARE + HOT + FISH + AS + THEIR + AFFILIATES + TAILOR + A + ROOFS + FOR + THEIR + SAFE == FORTRESSES")



