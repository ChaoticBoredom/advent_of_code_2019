require "pry"
class IntCode
  attr_reader :data, :output, :finished

  def initialize(data)
    @data = data
    @ip = 0
    @inputs = []
    @relative = 0
    @finished = false
  end

  def compute(stop_on_output: false, output: false)
    Kernel.loop do
      opcode, a, b, c = modes_data

      val1 = get_value(c, 1)
      val2 = get_value(b, 2)
      val3 = get_value(a, 3)

      case opcode
      when 1 then add(val1, val2, val3)
      when 2 then multiply(val1, val2, val3)
      when 3 then get_input(val1)
      when 4
        output_data(val1)
        puts "OUTPUT: #{@output}" if output
        return self if stop_on_output
      when 5 then true_jump(val1, val2)
      when 6 then false_jump(val1, val2)
      when 7 then less_than(val1, val2, val3)
      when 8 then equals(val1, val2, val3)
      when 9 then shift_relative_base(val1)
      when 99
        @finished = true
        return self
      else
        puts "UNKNOWN #{opcode} / #{@ip}"
        break
      end
    end

    self
  end

  def add_input(input)
    @inputs << input

    self
  end

  def reset
    @ip = 0
    @finished = false
    @relative = 0
    @output = nil

    self
  end

  private

  def modes_data
    modes = @data[@ip]
    opcode = modes % 100
    c, b, a = (modes / 100).digits

    a ||= 0
    b ||= 0
    c ||= 0

    [opcode, a, b, c]
  end

  def get_value(mode, offset)
    case mode
    when 0 then @data[@ip + offset]
    when 1 then @ip + offset
    when 2 then @data[@ip + offset] + @relative
    end
  end

  def add(val1, val2, val3)
    @data[val3] = read_param(val1) + read_param(val2)
    @ip += 4
  end

  def multiply(val1, val2, val3)
    @data[val3] = read_param(val1) * read_param(val2)
    @ip += 4
  end

  def get_input(val1)
    @data[val1] = @inputs.shift
    @ip += 2
  end

  def output_data(val1)
    @output = read_param(val1)
    @ip += 2
  end

  def true_jump(val1, val2)
    read_param(val1).zero? ? @ip += 3 : @ip = read_param(val2)
  end

  def false_jump(val1, val2)
    read_param(val1).zero? ? @ip = read_param(val2) : @ip += 3
  end

  def less_than(val1, val2, val3)
    @data[val3] = read_param(val1) < read_param(val2) ? 1 : 0
    @ip += 4
  end

  def equals(val1, val2, val3)
    @data[val3] = read_param(val1) == read_param(val2) ? 1 : 0
    @ip += 4
  end

  def shift_relative_base(val1)
    @relative += read_param(val1)
    @ip += 2
  end

  def read_param(val)
    @data[val] || 0
  end
end
