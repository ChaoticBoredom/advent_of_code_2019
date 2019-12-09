initial_input = File.open("input.txt") { |i| i.readline.strip.split(",").map(&:to_i) }
initial_input << 0 while initial_input.size < 5000

def get_value(data, mode, ip, offset, relative_base)
  case mode
  when 0 then data[ip + offset]
  when 1 then ip + offset
  when 2 then data[ip + offset] + relative_base
  end
end

def compute(data, ip, input)
  output = nil
  relative_base = 0
  Kernel.loop do
    modes = data[ip]

    opcode = modes % 100
    return [nil, ip, input] if opcode == 99

    c, b, a = (modes / 100).digits

    a ||= 0
    b ||= 0
    c ||= 0
    val1 = get_value(data, c, ip, 1, relative_base) || 0
    val2 = get_value(data, b, ip, 2, relative_base) || 0
    val3 = get_value(data, a, ip, 3, relative_base) || 0

    case opcode
    when 1
      data[val3] = data[val1] + data[val2]
      ip += 4
    when 2
      data[val3] = data[val1] * data[val2]
      ip += 4
    when 3
      data[val1] = input.shift
      ip += 2
    when 4
      puts "OUTPUT: #{data[val1]}"
      output = data[val1]
      ip += 2
    when 5 then data[val1].zero? ? ip += 3 : ip = data[val2]
    when 6 then data[val1].zero? ? ip = data[val2] : ip += 3
    when 7
      data[val3] = data[val1] < data[val2] ? 1 : 0
      ip += 4
    when 8
      data[val3] = data[val1] == data[val2] ? 1 : 0
      ip += 4
    when 9
      relative_base += data[val1]
      ip += 2
    else
      puts "UNKNOWN: #{opcode} / #{modes}"
      break
    end
  end

  [data, ip, output]
end

compute(initial_input, 0, [1])
