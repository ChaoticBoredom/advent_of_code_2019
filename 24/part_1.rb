require "pry"

initial_input = File.open("input.txt") do |f|
  f.readlines.map { |l| l.chomp.split("") }
end

def process(old_map)
  new_map = []
  old_map.first.size.times { new_map << [] }

  old_map.each.with_index do |val_y, y|
    val_y.each.with_index do |val_x, x|
      bug_count = 0
      curr_val = val_x
      [[x + 1, y], [x - 1, y], [x, y + 1], [x, y - 1]].each do |adj_x, adj_y|
        next if adj_y >= old_map.size || adj_y.negative?
        next if adj_x.negative?

        bug_count += 1 if old_map[adj_y][adj_x] == "#"
      end

      if curr_val == "#"
        curr_val = "." unless bug_count == 1
      elsif curr_val == "."
        curr_val = "#" if [1, 2].include?(bug_count)
      end
      new_map[y][x] = curr_val
    end
  end

  new_map
end

def biodiversity(bug_map)
  total = 0
  bug_map.flatten.each.with_index do |val, i|
    total += 2**i if val == "#"
  end
  total
end

layouts = []

curr_map = initial_input
until layouts.include?(curr_map)
  layouts << curr_map
  curr_map = process(curr_map)
end

puts "PART 1"
puts curr_map.map(&:join)
puts biodiversity(curr_map)
