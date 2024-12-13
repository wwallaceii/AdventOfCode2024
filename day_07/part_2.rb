# The engineers seem concerned; the total calibration result you gave them is nowhere close to being within safety tolerances. Just then, you spot your mistake: some well-hidden elephants are holding a third type of operator.

# The concatenation operator (||) combines the digits from its left and right inputs into a single number. For example, 12 || 345 would become 12345. All operators are still evaluated left-to-right.

# Now, apart from the three equations that could be made true using only addition and multiplication, the above example has three more equations that can be made true by inserting operators:

# 156: 15 6 can be made true through a single concatenation: 15 || 6 = 156.
# 7290: 6 8 6 15 can be made true using 6 * 8 || 6 * 15.
# 192: 17 8 14 can be made true using 17 || 8 + 14.
# Adding up all six test values (the three that could be made before using only + and * plus the new three that can now be made by also using ||) produces the new total calibration result of 11387.

# Using your new knowledge of elephant hiding spots, determine which equations could possibly be true. What is their total calibration result?

input_array = ARGV

def values_can_calculate_to_key?(target, total, values)
  if values.empty?
    return target == total
  end

  return values_can_calculate_to_key?(target, total + values.first, values.drop(1)) ||
    values_can_calculate_to_key?(target, total * values.first, values.drop(1)) ||
    values_can_calculate_to_key?(target, "#{total}#{values.first}".to_i, values.drop(1))
end

def solve_operations(equations)
  calibration_result = 0
  equations.each do |equation|
    key = equation[:key]
    values = equation[:values]
    result = values_can_calculate_to_key?(key, values.first, values.drop(1))

    if result
      calibration_result += key
    end
  end

  calibration_result
end

def process(file_name)
  equations = []
  File.foreach(ARGV[0]).with_index do |line, index|
    line_items = line.split(":")
    value = line_items[0].to_i
    values = line_items[1].strip.split(" ").map(&:to_i)

    equations << {
      key: value,
      values: values
    }
  end

  puts "Equations: #{equations.size}"
  results = solve_operations(equations)

  puts "Calibration result: #{results}"


end


process(input_array[0])
