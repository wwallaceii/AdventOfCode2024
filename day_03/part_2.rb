# As you scan through the corrupted memory, you notice that some of the conditional statements are also still intact. If you handle some of the uncorrupted conditional statements in the program, you might be able to get an even more accurate result.

# There are two new instructions you'll need to handle:

# The do() instruction enables future mul instructions.
# The don't() instruction disables future mul instructions.
# Only the most recent do() or don't() instruction applies. At the beginning of the program, mul instructions are enabled.

# For example:

# xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
# This corrupted memory is similar to the example from before, but this time the mul(5,5) and mul(11,8) instructions are disabled because there is a don't() instruction before them. The other mul instructions function normally, including the one at the end that gets re-enabled by a do() instruction.

# This time, the sum of the results is 48 (2*4 + 8*5).

# Handle the new instructions; what do you get if you add up all of the results of just the enabled multiplications?

input_array = ARGV

# Read the input file
def process(file_name)
  mult_sum = 0

  run_command = true
  File.foreach(ARGV[0]) do |line|

    pattern = /((mul\((\d+),\s*(\d+)\)|do\(\)|don't\(\)))/

    matches = line.scan(pattern)
    matches.each do |full_command, second_level_command, first_num, second_num|
      if full_command == "don't()"
        run_command = false
      elsif full_command == "do()"
        run_command = true
      end

      puts "Run: #{run_command}, Full Command: #{full_command} - Numbers: #{first_num}, #{second_num}"
      mult_sum += first_num.to_i * second_num.to_i if run_command && second_level_command.start_with?("mul")
    end
  end

puts "Sum of all multiplications: #{mult_sum}"
end

process(input_array[0])
