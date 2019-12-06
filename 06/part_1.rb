require "pry"
require "rgl/adjacency"
require "rgl/dijkstra"
require "rgl/traversal"
require "rgl/graph_visitor"
require "rgl/dijkstra_visitor"

orbits = File.readlines("input.txt").map { |l| l.strip.split(")") }

graph = RGL::AdjacencyGraph.new

weights = {}
suns = []
orbiters = []
orbits.each do |s, p|
  suns << s
  orbiters << p
  graph.add_edge s, p
  weights[[s, p]] = 1
end

root = suns.uniq - orbiters.uniq

visitor = RGL::DFSVisitor.new(graph)
visitor.attach_distance_map
graph.depth_first_visit(root.first, visitor) { |_| }

sum = graph.vertices.sum { |v| visitor.distance_to_root(v) }
puts sum

min_visitor = RGL::DijkstraVisitor.new(graph)
min_visitor.attach_distance_map
graph.dijkstra_shortest_path(weights, "YOU", "SAN", min_visitor) { |_| }
puts min_visitor.distance_map["SAN"] - 2 # Orbital hops is not the same as min distance
