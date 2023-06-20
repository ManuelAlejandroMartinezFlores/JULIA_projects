using POMDPs, POMDPModelTools, QuickPOMDPs

using DiscreteValueIteration

struct State 
    x::Int 
    y::Int 
end

@enum Action UP DOWN LEFT RIGHT

null = State(-1, -1)

Sval = [State(x, y) for x=1:4, y=1:3 if (x != 2 || y != 2)]
S = [Sval..., null]

const MOVES = Dict(
    UP => State(0, 1),
    DOWN => State(0, -1),
    LEFT => State(-1, 0),
    RIGHT => State(1, 0)
)

A = [UP, DOWN, LEFT, RIGHT]

Base.:+(s1::State, s2::State) = State(s1.x + s2.x, s1.y + s2.y)

function T(s::State, a::Action)
    if s == State(4, 2) || s == State(4, 3)
        return Deterministic(null)
    end

    prob = [(s + MOVES[act]) in S ? (act == a ? 0.7 : 0.1) : 0. for act in A]
    sts = [s + MOVES[act] for act in A]
    push!(prob, 1 - sum(prob))
    push!(sts, s)

    SparseCat(sts, prob)

end


R(s, a=missing) = s == State(4, 2) ? -100 : s == State(4, 3) ? 10 : 0


gamma = 0.95

termination(s::State) = s == null


abstract type GridWorld <: MDP{State, Action} end 

mdp = QuickMDP(GridWorld, 
    states = S, 
    actions = A,
    transition = T,
    reward = R,
    discount = gamma,
    isterminal = termination
)

solver = ValueIterationSolver(max_iterations = 1000)

policy = solve(solver, mdp)


using Plots


scatter([2, 4, 4], [2, 2, 3] , legend = false,
markercolor=[:gray, :red, :green], markershape=:rect, markersize=50)


for (s, a) in zip(S, policy.policy)
    s == State(-1, -1) || s == State(4, 3) ? continue : 0
    sp = s + MOVES[Action(a - 1)]
    plot!([s.x, sp.x], [s.y, sp.y], arrow=true, color=:dodgerblue)
end 
plot!(1, 1)
xlims!(0.9, 4.5)
ylims!(0.9, 3.5)