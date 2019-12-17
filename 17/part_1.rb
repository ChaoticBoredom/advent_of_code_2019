require "pry"
require_relative "../intcode"

def translate_map(map)
  map.
    join.
    gsub(/35/, "#").
    gsub(/46/, ".").
    gsub(/10/, "\n").
    gsub(/60/, "<").
    gsub(/62/, ">").
    gsub(/94/, "^").
    chomp
end

initial_input = File.open("input.txt") { |i| i.readline.strip.split(",").map(&:to_i) }

computer = IntCode.new(initial_input.dup)

output = []
output << computer.compute(stop_on_output: true).output until computer.finished

out_map = translate_map(output)

out_array = out_map.split("\n")

sum = 0
out_array.each.with_index do |row, i|
  row.split("").each.with_index do |column, j|
    next if column != "#"
    next if out_array[i + 1].nil?
    next if out_array[i + 1][j] != "#"
    next if out_array[i - 1][j] != "#"
    next if out_array[i][j + 1] != "#"
    next if out_array[i][j - 1] != "#"

    sum += i * j
  end
end

puts out_map

puts "PART 1"
puts sum

initial_input[0] = 2
computer = IntCode.new(initial_input)

path_a = "L,12,R,4,R,4,L,6\n".bytes
path_b = "L,10,L,6,R,4\n".bytes
path_c = "L,12,R,4,R,4,R,12\n".bytes
main_routine = "A,C,A,B,A,C,B,C,B,A\n".bytes
visual_feed = "n\n".bytes

[main_routine, path_a, path_b, path_c, visual_feed].each do |input|
  input.each do |v|
    computer.add_input(v)
  end
end
computer.compute

puts "PART 2"
puts computer.output
