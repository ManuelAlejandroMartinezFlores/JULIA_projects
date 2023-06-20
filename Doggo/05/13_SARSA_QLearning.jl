using POMDPs, POMDPModelTools, QuickPOMDPs

using DiscreteValueIteration, TabularTDLearning

using POMDPPolicies

using Random


struct State 
    x::Int 
end

@enum Action LEFT RIGHT 

null = State(-1)

Sval = [State(x) for x=1:7]

S = [Sval..., null]

A = [LEFT, RIGHT]

const MOVES = Dict(LEFT => State(-1), RIGHT => State(1))

Base.:+(s1::State, s2::State) = State(s1.x + s2.x)


function T(s::State, a::Action)
    if R(s) != 0 
        return Deterministic(null)
    end 

    prob = [s + MOVES[act] in Sval ? act == a ? 0.8 : 0.2 : 0. for act in A]
    push!(prob, 1 - sum(prob))
    sts = [s + MOVES[act] for act in A]
    push!(sts, s)

    SparseCat(sts, prob)
end


R(s, a=missing) = s == State(1) ? -1 : s == State(7) ? 1 : 0

termination(s::State) = s == null
abstract type GridWorld <: MDP{State, Action} end

gamma = 0.95

mdp = QuickMDP(GridWorld,
    states = S,
    actions = A,
    transition = T, 
    reward = R, 
    discount = gamma,
    isterminal = termination 
)

solver = ValueIterationSolver(max_iterations = 100)
policy = solve(solver, mdp)




############################################################
# SARSA 
############################################################

s_mdp = QuickMDP(GridWorld,
    states = S,
    actions = A,
    transition = T, 
    reward = R, 
    discount = gamma,
    isterminal = termination,
    # new line 
    initialstate = S
)

s_alpha = 0.5

s_nepisodes = 50

s_solver = SARSASolver(
    n_episodes = s_nepisodes, 
    learning_rate = s_alpha,
    exploration_policy = EpsGreedyPolicy(s_mdp, 0.5),
    verbose = false
)

s_policy = solve(s_solver, s_mdp)


############################################################
# Q - Learning  
############################################################


q_mdp = QuickMDP(GridWorld,
    states = S,
    actions = A,
    transition = T, 
    reward = R, 
    discount = gamma,
    isterminal = termination,
    # new line 
    initialstate = S
)

q_alpha = 0.5

q_nepisodes = 10

q_solver = QLearningSolver(
    n_episodes = s_nepisodes, 
    learning_rate = s_alpha,
    exploration_policy = EpsGreedyPolicy(q_mdp, 0.5),
    verbose = false
)

q_policy = solve(s_solver, s_mdp)