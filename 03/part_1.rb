wire1, wire2 = File.readlines("input.txt").map { |l| l.split(",") }

def build_array(wire)
  x = 0
  y = 0
  wire.reduce([]) do |arr, val|
    dir = val[0]
    values = val[1..-1].to_i
    values.times do
      case dir
      when "L"
        x -= 1
      when "R"
        x += 1
      when "U"
        y += 1
      when "D"
        y -= 1
      end

      arr.push([x, y])
    end
    arr
  end
end

arr1 = build_array(wire1)
arr2 = build_array(wire2)

intersections = arr1 & arr2

puts intersections.map { |x, y| x.abs + y.abs }.min
