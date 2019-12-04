input = File.open("input.txt") { |data| data.readline.strip.split(",").map(&:to_i) }

loc = 0

input[1] = 12
input[2] = 2

while loc + 3 < input.length
  puts "#{input[0 + loc]}, #{input[1 + loc]}, #{input[2 + loc]}, #{input[3]}"
  opcode = input[loc]
  val_one = input[loc + 1]
  val_two = input[loc + 2]
  break if opcode == 99
  val_three = if opcode == 1
                val_one + val_two
              elsif opcode == 2
                val_one * val_two
              end
  input[input[loc + 3]] = val_three
  puts "#{input[0 + loc]}, #{input[1 + loc]}, #{input[2 + loc]}, #{input[3]}"
  loc += 4
end

puts input[0]
