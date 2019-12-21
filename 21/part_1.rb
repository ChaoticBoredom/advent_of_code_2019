require "pry"
require_relative "../intcode"

program = File.open("input.txt") { |i| i.readline.strip.split(",").map(&:to_i) }

def run_spring_code(input, program)
  computer = IntCode.new(program.dup)

  input.each { |i| computer.add_input(i) }

  results = []
  results << computer.compute(stop_on_output: true).output until computer.finished

  results.compact!

  dmg = results.pop
  puts results.map(&:chr).join
  dmg
end

part1 = [
  "NOT A J",
  "NOT B T",
  "OR T J",
  "NOT C T",
  "OR T J",
  "AND D J",
  "WALK",
  nil,
].join("\n").bytes

puts "PART 1"
puts run_spring_code(part1, program)

part2 = [
  "NOT I T",
  "NOT T J",
  "OR F J",
  "AND E J",
  "OR H J",
  "AND D J",
  "NOT A T",
  "NOT T T",
  "AND B T",
  "AND C T",
  "NOT T T",
  "AND T J",
  "RUN",
  nil,
].join("\n").bytes

puts "PART 2"
puts run_spring_code(part2, program)
