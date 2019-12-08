input = File.new("input.txt").readline

width = 25
height = 6
size = width * height

arr = input.scan(/.{150}/)

min, max = arr.minmax_by { |v| v.count("0") }

puts min.count("1") * min.count("2")
