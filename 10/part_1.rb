require "pry"

@rows = []
input = "input.txt"
File.open(input) do |i|
  i.each_line { |l| @rows << l.chomp.split("") }
end

asteroids = {}

@rows.each.with_index do |line, i|
  line.each.with_index do |ast, j|
    next if ast == "."

    asteroids[[i, j]] = []
  end
end

def distance(ast1, ast2)
  dx = ast1[0] - ast2[0]
  dy = ast1[1] - ast2[1]

  m = (dx * dx + dy * dy)**0.5

  dx /= m
  dy /= m

  [dx.round(5), dy.round(5), m]
end

asteroids.each do |base, arr|
  asteroids.each do |ast, _|
    next if ast == base

    dx, dy, = distance(base, ast)
    arr << [dx, dy]
  end
end

puts asteroids.values.map(&:uniq).map(&:size).max
