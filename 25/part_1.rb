require "pry"
require_relative "../intcode"

initial_input = File.open("input.txt") { |i| i.readline.strip.split(",").map(&:to_i) }

computer = IntCode.new(initial_input.dup)
computer.compute(stop_on_input: true)

Kernel.loop do
  result = []
  until (x = computer.output).nil?
    result << x
  end

  required = ["easter egg", "hologram", "dark matter", "klein bottle"]
  puts "You need #{required.join(', ')}"
  puts result.map(&:chr).join
  input = gets.bytes
  computer.resume_on_input(input.shift) until input.empty?
end
