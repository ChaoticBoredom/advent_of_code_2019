inputs = File.readlines("input.txt")
puts inputs.map(&:strip).map(&:to_i).sum { |mass| mass / 3 - 2 }
