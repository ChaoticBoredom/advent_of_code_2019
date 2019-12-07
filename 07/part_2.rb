require "pry"
initial_input = File.open("input.txt") { |i| i.readline.strip.split(",").map(&:to_i) }

def compute(data, ip, input)
  ip = 0
  output = nil
  Kernel.loop do
    modes = data[ip]

    opcode = modes % 100
    break if opcode == 99

    c, b, = (modes / 100).digits

    b ||= 0
    c ||= 0
    val1 = c.zero? ? data[data[ip + 1]] : data[ip + 1]
    val2 = b.zero? ? data[data[ip + 2]] : data[ip + 2]
    val3 = data[ip + 3]

    case opcode
    when 1
      data[val3] = val1 + val2
      ip += 4
    when 2
      data[val3] = val1 * val2
      ip += 4
    when 3
      data[data[ip + 1]] = input.shift
      ip += 2
    when 4
      puts "OUTPUT: #{val1}"
      output = val1
      ip += 2
    when 5 then val1.zero? ? ip += 3 : ip = val2
    when 6 then val1.zero? ? ip = val2 : ip += 3
    when 7
      data[val3] = val1 < val2 ? 1 : 0
      ip += 4
    when 8
      data[val3] = val1 == val2 ? 1 : 0
      ip += 4
    else
      puts "UNKNOWN: #{opcode} / #{modes}"
      break
    end
  end

  [data, ip, output]
end

outputs = {}

[4, 3, 2, 1, 0].permutation do |phase|
  key = phase.dup
  _, _, a = compute(initial_input, 0, [phase.shift, 0])
  _, _, b = compute(initial_input, 0, [phase.shift, a])
  _, _, c = compute(initial_input, 0, [phase.shift, b])
  _, _, d = compute(initial_input, 0, [phase.shift, c])
  _, _, e = compute(initial_input, 0, [phase.shift, d])

  outputs[key] = e
end;

puts outputs.values.max
