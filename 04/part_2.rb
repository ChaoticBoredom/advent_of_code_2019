input = (254_032..789_860)

def six_digits?(val)
  val < 1_000_000 && val > 99_999
end

def never_decrease?(val)
  val.digits.each_cons(2) do |x, y|
    return false if x < y
  end
  true
end

def exactly_dupes?(val)
  val.
    digits.
    group_by(&:to_i).
    map { |k, v| [k, v.length] }.
    to_h.
    values.
    include?(2)
end

vals = []

input.each do |val|
  next unless never_decrease?(val)
  next unless exactly_dupes?(val)
  next unless six_digits?(val)

  vals << val
end

puts vals.size
