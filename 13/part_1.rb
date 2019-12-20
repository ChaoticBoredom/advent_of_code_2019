require "pry"
require_relative "../intcode"

initial_input = File.open("input.txt") { |i| i.readline.strip.split(",").map(&:to_i) }

computer = IntCode.new(initial_input.dup)

game_state = []
game_objects = { 1 => "|", 2 => "█", 3 => "_", 4 => "o" }

computer.compute
Kernel.loop do
  x = computer.output
  y = computer.output
  type = computer.output

  break if x.nil? || y.nil? || type.nil?

  game_state[y] ||= []
  game_state[y][x] = game_objects[type] || " "
end

puts "PART 1"
puts game_state.flatten.count("█")

def input(ball, paddle)
  ball[0] <=> paddle[0]
end

ball = game_state.map { |v| v.index("o") }.flatten.compact
paddle = game_state.map { |v| v.index("_") }.flatten.compact

score = 0
computer = IntCode.new(initial_input.dup)
computer.data[0] = 2
computer.compute(stop_on_input: true)
Kernel.loop do
  computer.resume_on_input(input(ball, paddle))

  Kernel.loop do
    x = computer.output
    y = computer.output
    type = computer.output

    break if x.nil? || y.nil? || type.nil?

    ball = [x, y] if type == 4
    paddle = [x, y] if type == 3
    score = type if x.negative?

    game_state[y] ||= []
    game_state[y][x] = game_objects.fetch(type, " ")
  end

  # puts game_state.map(&:join)
  # puts score

  break if game_state.flatten.count("█").zero?
end

puts "PART 2"
puts score
