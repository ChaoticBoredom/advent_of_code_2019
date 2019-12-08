input = File.new("input.txt").readline

arr = input.scan(/.{150}/)

min, _ = arr.minmax_by { |v| v.count("0") }

puts min.count("1") * min.count("2")
