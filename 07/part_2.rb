@data = File.open("input.txt") { |i| i.readline.strip.split(",").map(&:to_i) }

def add(val1, val2, val3)
  @data[val3] = val1 + val2
  @i += 4
end

def multiply(val1, val2, val3)
  @data[val3] = val1 * val2
  @i += 4
end

def save_input(input)
  @data[@data[@i + 1]] = input
  @i += 2
end

def output(val1)
  puts "OUTPUT: #{val1}"
  @output = val1
  @i += 2
end

def jump_if_true(val1, val2)
  val1.zero? ? @i += 3 : @i = val2
end

def jump_if_false(val1, val2)
  val1.zero? ? @i = val2 : @i += 3
end

def less_than(val1, val2, val3)
  @data[val3] = val1 < val2 ? 1 : 0
  @i += 4
end

def equals(val1, val2, val3)
  @data[val3] = val1 == val2 ? 1 : 0
  @i += 4
end

def compute(input)
  @i = 0
  Kernel.loop do
    modes = @data[@i]

    opcode = modes % 100
    break if opcode == 99

    c, b, = (modes / 100).digits

    b ||= 0
    c ||= 0
    val1 = c.zero? ? @data[@data[@i + 1]] : @data[@i + 1]
    val2 = b.zero? ? @data[@data[@i + 2]] : @data[@i + 2]
    val3 = @data[@i + 3]

    case opcode
    when 1 then add(val1, val2, val3)
    when 2 then multiply(val1, val2, val3)
    when 3 then save_input(input.shift)
    when 4 then output(val1)
    when 5 then jump_if_true(val1, val2)
    when 6 then jump_if_false(val1, val2)
    when 7 then less_than(val1, val2, val3)
    when 8 then equals(val1, val2, val3)
    else
      puts "UNKNOWN: #{opcode} / #{modes}"
      break
    end
  end

  @output
end

outputs = {}

[4, 3, 2, 1, 0].permutation do |phase|
  key = phase.dup
  a = compute([phase.shift, 0])
  b = compute([phase.shift, a])
  c = compute([phase.shift, b])
  d = compute([phase.shift, c])
  e = compute([phase.shift, d])

  outputs[key] = e
end

puts outputs.max_by { |_, v| v }
