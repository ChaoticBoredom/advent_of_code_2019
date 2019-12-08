require "pry"
input = File.new("input.txt").readline

arr = input.scan(/.{150}/)

def collapse(arr_collection)
  final = []

  150.times do |i|
    arr_collection.each do |a|
      next if a[i] == "2"

      final << a[i]
      break
    end
  end

  final.join.gsub!("0", " ")
end

puts collapse(arr).scan(/.{25}/)
