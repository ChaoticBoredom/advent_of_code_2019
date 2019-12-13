require "pry"
require_relative "../intcode"

initial_input = File.open("input.txt") { |i| i.readline.strip.split(",").map(&:to_i) }

def compute(data, ip, input)
  output = nil
  Kernel.loop do
    modes = data[ip]

    opcode = modes % 100
    return [nil, ip, input] if opcode == 99

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
      return [data, ip, output]
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

[5, 6, 7, 8, 9].permutation do |phase|
  key = phase.dup
  da, ia, a = compute(initial_input.dup, 0, [phase.shift, 0])
  db, ib, b = compute(initial_input.dup, 0, [phase.shift, a])
  dc, ic, c = compute(initial_input.dup, 0, [phase.shift, b])
  dd, id, d = compute(initial_input.dup, 0, [phase.shift, c])
  de, ie, e = compute(initial_input.dup, 0, [phase.shift, d])

  loop do
    da, ia, a = compute(da, ia, [e])
    db, ib, b = compute(db, ib, [a])
    dc, ic, c = compute(dc, ic, [b])
    dd, id, d = compute(dd, id, [c])
    de, ie, e = compute(de, ie, [d])
    outputs[key] = e if e
    break unless de
  end
end

puts outputs.values.max

vals = [5, 6, 7, 8, 9].permutation.map do |phase|
  computer_a = IntCode.new(initial_input.dup).add_input(phase.shift).add_input(0).compute(stop_on_output: true)
  computer_b = IntCode.new(initial_input.dup).add_input(phase.shift).add_input(computer_a.output).compute(stop_on_output: true)
  computer_c = IntCode.new(initial_input.dup).add_input(phase.shift).add_input(computer_b.output).compute(stop_on_output: true)
  computer_d = IntCode.new(initial_input.dup).add_input(phase.shift).add_input(computer_c.output).compute(stop_on_output: true)
  computer_e = IntCode.new(initial_input.dup).add_input(phase.shift).add_input(computer_d.output).compute(stop_on_output: true)

  loop do
    computer_a.add_input(computer_e.output).compute(stop_on_output: true)
    computer_b.add_input(computer_a.output).compute(stop_on_output: true)
    computer_c.add_input(computer_b.output).compute(stop_on_output: true)
    computer_d.add_input(computer_c.output).compute(stop_on_output: true)
    computer_e.add_input(computer_d.output).compute(stop_on_output: true)
    break if computer_e.finished
  end
  computer_e.output
end

puts vals.max
