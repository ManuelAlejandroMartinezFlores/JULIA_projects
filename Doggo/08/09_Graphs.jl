using Graphs, GraphRecipes, Plots

g = Graph(3, 2)

graphplot(g)

elabel = Dict((1, 2) => 1, (1, 3) => 2)

viewgraph(g) = graphplot(g, names=1:nv(g), edgelabel = elabel, 
    curves=false, nodeshape=:circle, nodesize=0.2, linewidth=2)

viewgraph(g)

g = Graph()
add_vertices!(g, 3)
add_edge!(g, 1, 2)
add_edge!(g, 1, 3)

viewgraph(g)


g = DiGraph()
add_vertices!(g, 3)
add_edge!(g, 1, 2)
add_edge!(g, 1, 3)
add_edge!(g, 2, 3)

rem_edge!(g, 2, 3)

viewgraph(g)


using SimpleWeightedGraphs


from = [1, 1, 2, 2, 3, 4, 4, 5, 5, 6, 7, 8]
to = [2, 4, 3, 5, 6, 5, 7, 6, 8, 9, 8, 9]
W = round.(rand(12), digits=2)

g = WGraph(from, to, W)

lab = Dict((f, t) => w for (f, t, w) in zip(from, to, W))

graphplot(g, names=1:nv(g), edgelabel = lab,
    curves=false, nodeshape=:circle, nodesize=0.2, linewidth=2)


path = enumerate_paths(dijkstra_shortest_paths(g, 1), 9)

colors = [n in path ? :lightgreen : :lightgray for n in 1:nv(g)]

graphplot(g, names=1:nv(g), edgelabel = lab, markercolor=colors,
    curves=false, nodeshape=:circle, nodesize=0.2, linewidth=2)