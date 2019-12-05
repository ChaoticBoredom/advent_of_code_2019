input = File.open("input.txt") { |data| data.readline.strip.split(",").map(&:to_i) }

input[1] = 12
input[2] = 2

input.each_slice(4) do |part|
  puts part.join(",")
  break if part[0] == 99

  new_val = if part[0] == 1
              input[part[1]] + input[part[2]]
            elsif part[0] == 2
              input[part[1]] * input[part[2]]
            end
  input[part[3]] = new_val
end

puts input[0]
