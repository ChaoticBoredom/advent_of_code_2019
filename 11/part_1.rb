require "pry"
require_relative "../intcode"

initial_input = File.open("input.txt") { |i| i.readline.strip.split(",").map(&:to_i) }

computer = IntCode.new(initial_input.dup)

loc = [0, 0]
panels = Hash.new(0)
robot_facing = :n
DIRS = [:n, :w, :s, :e].freeze
DIR_CHANGES = { :n => [0, 1], :w => [-1, 0], :s => [0, -1], :e => [1, 0] }.freeze

def move_robot(loc, turn, robot_facing)
  if turn.zero?
    x = DIRS.index(robot_facing) + 1
    x = 0 if x >= DIRS.size
    robot_facing = DIRS[x]
  else
    robot_facing = DIRS[DIRS.index(robot_facing) - 1]
  end

  move_dir = DIR_CHANGES[robot_facing]
  new_loc = [loc[0] + move_dir[0], loc[1] + move_dir[1]]
  [new_loc, robot_facing]
end

until computer.finished
  original_colour = panels[loc]
  colour = computer.add_input(original_colour).compute(stop_on_output: true).output
  turn = computer.compute(stop_on_output: true).output
  panels[loc] = colour

  loc, robot_facing = move_robot(loc, turn, robot_facing)
end

puts "PART 1"
puts panels.keys.count

computer = IntCode.new(initial_input.dup)

loc = [0, 0]
panels = Hash.new(0)
panels[loc] = 1
until computer.finished
  original_colour = panels[loc]
  colour = computer.add_input(original_colour).compute(stop_on_output: true).output
  turn = computer.compute(stop_on_output: true).output
  panels[loc] = colour

  loc, robot_facing = move_robot(loc, turn, robot_facing)
end

max_x = panels.keys.map(&:first).max + 2
x_increment = panels.keys.map(&:first).min.abs
y_increment = panels.keys.map(&:last).min.abs

paint_job = []
panels.each do |k, v|
  x, y = k
  paint_job[y + y_increment] ||= Array.new(max_x + x_increment, " ")
  paint_job[y + y_increment][x + x_increment] = v.zero? ? " " : "█"
end

puts "PART 2"
puts(paint_job.map { |pj| pj.map { |v| v.nil? ? " " : v }.reverse.join })
