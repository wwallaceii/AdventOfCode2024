# The reindeer spends a few minutes reviewing your hiking trail map before realizing something, disappearing for a few minutes, and finally returning with yet another slightly-charred piece of paper.

# The paper describes a second way to measure a trailhead called its rating. A trailhead's rating is the number of distinct hiking trails which begin at that trailhead. For example:

# .....0.
# ..4321.
# ..5..2.
# ..6543.
# ..7..4.
# ..8765.
# ..9....
# The above map has a single trailhead; its rating is 3 because there are exactly three distinct hiking trails which begin at that position:

# .....0.   .....0.   .....0.
# ..4321.   .....1.   .....1.
# ..5....   .....2.   .....2.
# ..6....   ..6543.   .....3.
# ..7....   ..7....   .....4.
# ..8....   ..8....   ..8765.
# ..9....   ..9....   ..9....
# Here is a map containing a single trailhead with rating 13:

# ..90..9
# ...1.98
# ...2..7
# 6543456
# 765.987
# 876....
# 987....
# This map contains a single trailhead with rating 227 (because there are 121 distinct hiking trails that lead to the 9 on the right edge and 106 that lead to the 9 on the bottom edge):

# 012345
# 123456
# 234567
# 345678
# 4.6789
# 56789.
# Here's the larger example from before:

# 89010123
# 78121874
# 87430965
# 96549874
# 45678903
# 32019012
# 01329801
# 10456732
# Considering its trailheads in reading order, they have ratings of 20, 24, 10, 4, 1, 4, 5, 8, and 5. The sum of all trailhead ratings in this larger example topographic map is 81.

# You're not sure how, but the reindeer seems to have crafted some tiny flags out of toothpicks and bits of paper and is using them to mark trailheads on your topographic map. What is the sum of the ratings of all trailheads?

input_array = ARGV

def walk_trails(x, y, prev_x, prev_y, topographic_map, path, trailends = {}, debug=false)
  path.push "#{x},#{y}"

  if x < 0 || y < 0 || x >= topographic_map[0].length || y >= topographic_map.length
    return
  end

  if !prev_x.nil? && !prev_y.nil? && (topographic_map[y][x] - topographic_map[prev_y][prev_x]) != 1
    return
  end

  if topographic_map[y][x] == 9
    trailends["#{x},#{y}"] = [] if trailends["#{x},#{y}"].nil?
    trailends["#{x},#{y}"] << path
    return
  end


  walk_trails(x+1, y, x, y, topographic_map, path.dup, trailends, debug)
  walk_trails(x-1, y, x, y, topographic_map, path.dup, trailends, debug)
  walk_trails(x, y+1, x, y, topographic_map, path.dup, trailends, debug)
  walk_trails(x, y-1, x, y, topographic_map, path.dup, trailends, debug)
end

def find_trailhead_scores_and_ratings(topographic_map, trailhead_starts, debug=false)
  scores = 0
  ratings = 0
  trailhead_starts.each do |trailhead_start|
    trailends = {}
    walk_trails(trailhead_start[:x], trailhead_start[:y], nil, nil, topographic_map, [], trailends, debug)
    puts "#{trailhead_start} => #{trailends.keys}" if debug
    ratings += trailends.values.sum(&:length)
    scores += trailends.keys.length
  end

  {
    scores: scores,
    ratings: ratings,
  }
end

def process(file_name, debug=false)

  topographic_map = []
  trailhead_starts = []

  File.foreach(ARGV[0]).with_index do |line, index|
    row = line.strip.chars.map(&:to_i)
    row.each_index.select { |i| row[i] == 0 }.each do |i|
      trailhead_starts.push({ x: i, y: index })
    end
    topographic_map.push(row)
  end

  if debug
    puts "topographic_map:"
    topographic_map.each do |row|
      puts row.join
    end
    puts "trailhead_starts: #{trailhead_starts.join(", ")}"
  end

  scores_and_ratings = find_trailhead_scores_and_ratings(topographic_map, trailhead_starts, debug)
  puts "Sum of the scores of all trailheads: #{scores_and_ratings[:scores]}"
  puts "Sum of the ratings of all trailheads: #{scores_and_ratings[:ratings]}"

end


process(input_array[0], !input_array.at(1).nil?)
