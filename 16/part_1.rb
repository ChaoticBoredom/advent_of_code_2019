require "pry"
PATTERN = [0, 1, 0, -1].freeze

input = File.open("input.txt") { |i| i.readline.chomp }.split("").map(&:to_i)

def solve_phase(input, phase)
  pattern = PATTERN.flat_map { |v| [v] * phase }
  pattern.rotate!
  cycle = pattern.cycle

  input.
    map { |v| v * cycle.next }.
    sum.
    abs % 10
end

def solve_phase_part2(input)
  s = input.sum
  input.map do |i|
    val = ((s % 10) + 10) % 10
    s -= i
    val
  end
end

100.times do
  input = input.map.with_index(1) do |_, i|
    solve_phase(input.freeze, i)
  end
end

puts "PART 1"
puts input.join[0...8]

input = File.open("input.txt") { |i| i.readline.chomp }.split("").map(&:to_i)
offset = input.join[0...7].to_i

part2 = input * 10_000

100.times do
  part2 = solve_phase_part2(part2)
end

puts "PART 2"
puts part2.join[offset...offset + 8]
