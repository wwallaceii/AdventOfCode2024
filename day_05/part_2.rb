# While the Elves get to work printing the correctly-ordered updates, you have a little time to fix the rest of them.

# For each of the incorrectly-ordered updates, use the page ordering rules to put the page numbers in the right order. For the above example, here are the three incorrectly-ordered updates and their correct orderings:

# 75,97,47,61,53 becomes 97,75,47,61,53.
# 61,13,29 becomes 61,29,13.
# 97,13,75,29,47 becomes 97,75,47,29,13.
# After taking only the incorrectly-ordered updates and ordering them correctly, their middle page numbers are 47, 29, and 47. Adding these together produces 123.

# Find the updates which are not in the correct order. What do you get if you add up the middle page numbers after correctly ordering just those updates?

input_array = ARGV

def calculate_sum_of_valid_update_middle_numbers(rules, updates)
  valid_middle_sum = 0
  fixed_middle_sum = 0
  updates.each do |update|
    valid = true
    update.each_with_index do |page, index|
      test = update.dup.drop(index + 1)
      # puts "Update: #{update} - Page: #{page} - Test: #{test}"
      if test.empty?
        valid = true
        break
      end

      valid = test.all? do |test_page|

       rules[page][:before].include?(test_page) || (!rules[page][:before].include?(test_page) && !rules[page][:after].include?(test_page))
      end

      if !valid
        break
      end
    end
    if valid
      valid_middle_sum += update[update.size / 2]
    else
      update.sort! do |page1, page2|

        if !rules[page1].nil? && rules[page1][:before].include?(page2)
          -1
        elsif !rules[page1].nil? && rules[page1][:after].include?(page2)
          1
        else
          0
        end
      end
      fixed_middle_sum += update[update.size / 2]
    end
  end
  [valid_middle_sum, fixed_middle_sum]
end

def process(file_name)
  rules = {}
  updates = []
  File.foreach(ARGV[0]) do |line|
    if line.include?("|")
      nums = line.split("|").map(&:to_i)
      rules[nums[0]] = {
        before: [],
        after: []
      } if !rules[nums[0]]

      rules[nums[1]] = {
        before: [],
        after: []
      } if !rules[nums[1]]

      rules[nums[0]][:before].push(nums[1])
      rules[nums[1]][:after].push(nums[0])
    else
      updates.push(line.split(",").map(&:to_i)) if !line.strip.empty?
    end
  end

  # rules.each do |k, v|
  #   puts "#{k} - #{v}"
  # end

  # updates.each do |update|
  #   puts "#{update}"
  # end

  sums = calculate_sum_of_valid_update_middle_numbers(rules, updates)
  puts "Valid middle sum: #{sums[0]}, Fixed middle sum: #{sums[1]}"
end


process(input_array[0])
