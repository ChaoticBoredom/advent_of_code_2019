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

puts "PART 1"
puts asteroids.values.map(&:uniq).map(&:size).max

base = asteroids.max_by { |_, v| v.uniq.size }[0]

angles = {}

asteroids.each do |ast, _|
  next if ast == base

  dx, dy, = distance(base, ast)
  key = Math.atan2(dx, dy).round(5)
  angles[key] ||= []
  angles[key] << ast
end

def print_field(ast, base)
  @rows[base[0]][base[1]] = "X"
  @rows[ast[0]][ast[1]] = "."
  puts @rows.map(&:join)
  sleep(0.2)
end

def distance_from_base(ast, base)
  x_dist = ast[0] - base[0]
  y_dist = ast[1] - base[1]
  Math.sqrt(x_dist * x_dist + y_dist * y_dist)
end

counter = 0
winner = nil
sorted_angles = angles.sort
NORTH = 1.5708
rotate_count = sorted_angles.index([NORTH, angles[NORTH]])
sorted_angles = angles.sort.rotate(rotate_count)

while counter < 200
  sorted_angles.each do |_, asteroid_list|
    asteroid = asteroid_list.sort_by { |a| distance_from_base(a, base) }.shift
    counter += 1 if asteroid
    if counter == 200
      winner = asteroid.reverse.join(",")
      break
    end
  end
end

puts "PART 2"
puts winner
