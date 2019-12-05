require "pry"
data = File.open("input.txt") { |i| i.readline.strip.split(",").map(&:to_i) }

def add(val1, val2)
  val1 + val2
end

def multiply(val1, val2)
  val1 * val2
end

def save_input
  print "ENTER INPUT: "
  gets.chomp.to_i
end

def output(val1)
  puts "OUTPUT: #{val1}"
end

def jump_if_true(val1)
  val1.zero?
end

def jump_if_false(val1)
  val1.zero?
end

def less_than(val1, val2)
  val1 < val2 ? 1 : 0
end

def equals(val1, val2)
  val1 == val2 ? 1 : 0
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
    output(val1)
    i += 2
  when 5
    jump_if_true(val1) ? i += 3 : i = val2
  when 6
    jump_if_false(val1) ? i = val2 : i += 3
  when 7
    data[val3] = less_than(val1, val2)
    i += 4
  when 8
    data[val3] = equals(val1, val2)
    i += 4
  else
    puts "UNKNOWN: #{opcode} / #{modes}"
  end
end
