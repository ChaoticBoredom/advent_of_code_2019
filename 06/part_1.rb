require "pry"
require "rgl/adjacency"
require "rgl/traversal"
require "rgl/graph_visitor"

orbits = File.readlines("input.txt").map { |l| l.strip.split(")") }

graph = RGL::AdjacencyGraph.new

suns = []
orbiters = []
orbits.each do |s, p|
  suns << s
  orbiters << p
  graph.add_edge s, p
end

root = suns.uniq - orbiters.uniq

visitor = RGL::DFSVisitor.new(graph)
visitor.attach_distance_map
graph.depth_first_visit(root.first, visitor) { |_| }

puts graph.vertices.sum { |v| visitor.distance_to_root(v) }
