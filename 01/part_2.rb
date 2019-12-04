def calc_fuel_load(fuel)
  total_fuel = 0
  while fuel.positive?
    fuel = fuel / 3 - 2
    break if fuel.negative?

    total_fuel += fuel
  end

  total_fuel
end

inputs = File.readlines("input.txt")
fuel = inputs.map(&:strip).map(&:to_i).sum do |mass|
  f = mass / 3 - 2
  f + calc_fuel_load(f)
end

puts fuel
