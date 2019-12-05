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

def adjacent_dupes?(val)
  val.digits.each_cons(2) do |x, y|
    return true if x == y
  end
end

vals = []

input.each do |val|
  next unless never_decrease?(val)
  next unless adjacent_dupes?(val)
  next unless six_digits?(val)

  vals << val
end

puts vals.size
