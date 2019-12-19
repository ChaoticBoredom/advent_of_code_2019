require "pry"
require_relative "../intcode"

PROGRAM = File.open("input.txt") { |i| i.readline.strip.split(",").map(&:to_i) }

def tractored?(x, y)
  computer = IntCode.new(PROGRAM.dup)
  computer.add_input(x)
  computer.add_input(y)

  computer.compute.output
end

count = 0
(0...50).each do |x|
  (0...50).each do |y|
    count += tractored?(x, y)
  end
end

puts "PART 1"
puts count

origin_x = nil
origin_y = nil

(0...100_000).each do |x|
  start_found = false
  (0...100_000).each do |y|
    next if tractored?(x, y).zero?

    next if tractored?(x + 100, y).zero?
    next if tractored?(x, y + 100).zero?
    next if tractored?(x + 100, y + 100).zero?

    # next if tractored?(x + 50, y).zero?
    # next if tractored?(x, y + 50).zero?
    # next if tractored?(x + 1, y).zero?
    # next if tractored?(x, y + 1).zero?

    origin_x = x
    origin_y = y
    break if origin_y
  end
  puts "next x = #{x}"
  break if origin_x
end

puts "PART 2"
puts [origin_x * 10_000, origin_y].sum
