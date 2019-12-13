require "pry"
require_relative "../intcode"

initial_input = File.open("input.txt") { |i| i.readline.strip.split(",").map(&:to_i) }

computer = IntCode.new(initial_input.dup)

game = []
objects = {}

until computer.finished
  obj = []
  3.times do
    obj << computer.compute(stop_on_output: true).output
  end

  objects[obj[2]] ||= []
  objects[obj[2]] << [obj[0], obj[1]]
end

binding.pry
puts objects.keys
puts objects[2].count
