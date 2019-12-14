require "pry"

class Moon
  attr_reader :position, :velocity

  def initialize(pos)
    @position = pos
    @velocity = [0, 0, 0]
  end

  def add_velocity(new_vel)
    @velocity[0] += new_vel[0]
    @velocity[1] += new_vel[1]
    @velocity[2] += new_vel[2]
  end

  def update_position
    @position[0] += @velocity[0]
    @position[1] += @velocity[1]
    @position[2] += @velocity[2]
  end

  def energy
    @position.map(&:abs).sum * @velocity.map(&:abs).sum
  end

  def to_s
    position = "<x=#{@position[0]}, y=#{@position[1]}, z=#{@position[2]}>"
    velocity = "<x=#{@velocity[0]}, y=#{@velocity[1]}, z=#{@velocity[2]}>"
    [position, velocity].join(", ")
  end
end

def get_velocity(moon1, moon2)
  moon1_position = moon1.position
  moon2_position = moon2.position
  x = moon2_position[0] <=> moon1_position[0]
  y = moon2_position[1] <=> moon1_position[1]
  z = moon2_position[2] <=> moon1_position[2]
  [x, y, z]
end

def collapse_velocities(vel_list)
  vel = [0, 0, 0]
  vel_list.each do |v|
    vel[0] += v[0]
    vel[1] += v[1]
    vel[2] += v[2]
  end
  vel
end

def step(moons)
  moons.each do |m1|
    vel_list = moons.map do |m2|
      next if m1 == m2

      get_velocity(m1, m2)
    end

    m1.add_velocity(collapse_velocities(vel_list.compact))
  end

  moons.each(&:update_position)
end

moons = File.open("input.txt").readlines.map do |m|
  Moon.new(m.scan(/-?\d+/).map(&:to_i))
end

1000.times { step(moons) }

puts "PART 1"
puts moons.map(&:energy).sum

moons = File.open("input.txt").readlines.map do |m|
  Moon.new(m.scan(/-?\d+/).map(&:to_i))
end
states = [[], [], []]
300_000.times do
  states.each.with_index do |_, i|
    states[i] << [
      moons[0].position[i],
      moons[1].position[i],
      moons[2].position[i],
      moons[3].position[i],
      moons[0].velocity[i],
      moons[1].velocity[i],
      moons[2].velocity[i],
      moons[3].velocity[i],
    ]
  end
  step(moons)
end

period = states.map do |points|
  points.each_index.select { |i| points[i] == points[0] }[1]
end

puts "PART 2"
puts period.inject(:lcm)
