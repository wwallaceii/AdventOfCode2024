# The engineers are surprised by the low number of safe reports until they realize they forgot to tell you about the Problem Dampener.

# The Problem Dampener is a reactor-mounted module that lets the reactor safety systems tolerate a single bad level in what would otherwise be a safe report. It's like the bad level never happened!

# Now, the same rules apply as before, except if removing a single level from an unsafe report would make it safe, the report instead counts as safe.

# More of the above example's reports are now safe:

# 7 6 4 2 1: Safe without removing any level.
# 1 2 7 8 9: Unsafe regardless of which level is removed.
# 9 7 6 2 1: Unsafe regardless of which level is removed.
# 1 3 2 4 5: Safe by removing the second level, 3.
# 8 6 4 4 1: Safe by removing the third level, 4.
# 1 3 6 7 9: Safe without removing any level.
# Thanks to the Problem Dampener, 4 reports are actually safe!

# Update your analysis by handling situations where the Problem Dampener can remove a single level from unsafe reports. How many reports are now safe?

input_array = ARGV

def is_report_safe?(report, threshold)
  safe_report = false

  prev_difference = nil
  previous_good_level = nil
  bad_levels = 0
  previous_good_level = report.first
  report.each_cons(2) do |a, b|
    difference = previous_good_level - b

    if !prev_difference.nil? && prev_difference.negative? && !difference.negative?
      bad_levels += 1
    elsif !prev_difference.nil? && prev_difference.positive? && !difference.positive?
      bad_levels += 1
    elsif difference.abs > 3 || difference.abs < 1
      bad_levels += 1
    else
      previous_good_level = b
      prev_difference = difference
    end

    if bad_levels > threshold
      safe_report = false
      break
    else
      safe_report = true
    end
  end

  # puts "Report: #{report} - Safe: #{safe_report}, Bad levels: #{bad_levels}" if !safe_report
  safe_report
end

def calculate_safe_reports(reports, threshold = 0, debug = false)
  safe_report_count = 0

  reports.each do |report|
    safe_report = is_report_safe?(report, threshold)

    (0...report.size).each do |i|
      modified_report = report.dup
      modified_report.delete_at(i)
      safe_report = is_report_safe?(modified_report, threshold-1)
      break if safe_report
    end
    safe_report_count += 1 if safe_report
  end

  safe_report_count
end

# Read the input file
def process(file_name)
  reports = []
  File.foreach(ARGV[0]) do |line|
    items = line.split(" ")
    reports.push(items.map(&:to_i))
  end

  puts "Safe reports: #{calculate_safe_reports(reports, 1, true)}"
end

process(input_array[0])
