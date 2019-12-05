require "pry"
data = File.open("input.txt") { |i| i.readline.strip.split(",").map(&:to_i) }

def add(val1, val2)
  val1 + val2
end

def multiply(val1, val2)
  val1 * val2
end

def save_input
  puts "ENTER INPUT"
  gets.chomp.to_i
end

def output(data, val1)
  puts "OUTPUT: #{val1}"
  puts data[val1]
end

i = 0
Kernel.loop do
  modes = data[i]

  opcode = modes % 100
  break if opcode == 99

  c, b, = (modes / 100).digits

  b ||= 0
  c ||= 0
  val1 = c.zero? ? data[data[i + 1]] : data[i + 1]
  val2 = b.zero? ? data[data[i + 2]] : data[i + 2]
  val3 = data[i + 3]

  puts data[i..i + 3].join(", ")

  case opcode
  when 1
    data[val3] = add(val1, val2)
    i += 4
  when 2
    data[val3] = multiply(val1, val2)
    i += 4
  when 3
    data[data[i + 1]] = save_input
    i += 2
  when 4
    output(data, val1)
    i += 2
  else
    puts "UNKNOWN: #{opcode} / #{modes}"
  end
end
