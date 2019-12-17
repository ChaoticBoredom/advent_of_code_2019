require "pry"
require_relative "../intcode"

initial_input = File.open("input.txt") { |i| i.readline.strip.split(",").map(&:to_i) }

computer = IntCode.new(initial_input.dup)

output = []
until computer.finished
  output << computer.compute(stop_on_output: true).output
end

out_map = output.join.gsub(/35/, "#").gsub(/46/, ".").gsub(/10/, "\n").gsub(/60/, "<").gsub(/62/, ">").gsub(/94/, "^").chomp

out_array = out_map.split("\n")
puts out_map

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

puts "PART 1"
puts sum
