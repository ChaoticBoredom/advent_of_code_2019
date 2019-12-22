require "pry"

def deal_int(card, deck_size)
  deck_size - card - 1
end

def cut_int(card, deck_size, cut)
  if cut.positive?
    (card - cut + deck_size) % deck_size
  else
    (card + cut.abs) % deck_size
  end
end

def deal_with_increment_int(card, deck_size, increment)
  card * increment % deck_size
end

def parse_instruction_int(line, card, deck_size)
  case line
  when /deal with/
    v = /\d+/.match(line)[0].to_i
    deal_with_increment_int(card, deck_size, v)
  when /cut/
    v = /-?\d+/.match(line)[0].to_i
    cut_int(card, deck_size, v)
  when /deal into/
    deal_int(card, deck_size)
  end
end

def solve(iterations, instructions, deck_size, card)
  count = 0
  iterations.times do
    count += 1
    puts count if (count % 1_000_000).zero?
    instructions.each do |l|
      card = parse_instruction_int(l, card, deck_size)
    end
  end
  card
end

instructions = File.open("input.txt").readlines.map(&:chomp)

puts "PART 1"
puts solve(1, instructions, 10_007, 2019)

puts "PART 2"
puts solve(101_741_582_076_661, instructions, 119_315_717_514_047, 2020)
