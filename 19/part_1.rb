require "pry"
require_relative "../intcode"

PROGRAM = File.open("input.txt") { |i| i.readline.strip.split(",").map(&:to_i) }

def tractored?(row, col)
  computer = IntCode.new(PROGRAM.dup)
  computer.add_input(row)
  computer.add_input(col)

  computer.compute.output == 1
end

count = 0
(0...50).each do |x|
  (0...50).each do |y|
    count += 1 if tractored?(x, y)
  end
end

puts "PART 1"
puts count

origin_x = nil
origin_y = nil

x = 0
y = 99
while origin_x.nil?
  x += 1 unless tractored?(x, y)
  if tractored?(x + 99, y - 99)
    origin_x = x
    origin_y = y - 99
  end
  y += 1 if tractored?(x, y)
end

puts "PART 2"
puts [origin_x * 10_000, origin_y].sum
