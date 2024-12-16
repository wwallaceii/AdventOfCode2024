# You all arrive at a Lava Production Facility on a floating island in the sky. As the others begin to search the massive industrial complex, you feel a small nose boop your leg and look down to discover a reindeer wearing a hard hat.

# The reindeer is holding a book titled "Lava Island Hiking Guide". However, when you open the book, you discover that most of it seems to have been scorched by lava! As you're about to ask how you can help, the reindeer brings you a blank topographic map of the surrounding area (your puzzle input) and looks up at you excitedly.

# Perhaps you can help fill in the missing hiking trails?

# The topographic map indicates the height at each position using a scale from 0 (lowest) to 9 (highest). For example:

# 0123
# 1234
# 8765
# 9876
# Based on un-scorched scraps of the book, you determine that a good hiking trail is as long as possible and has an even, gradual, uphill slope. For all practical purposes, this means that a hiking trail is any path that starts at height 0, ends at height 9, and always increases by a height of exactly 1 at each step. Hiking trails never include diagonal steps - only up, down, left, or right (from the perspective of the map).

# You look up from the map and notice that the reindeer has helpfully begun to construct a small pile of pencils, markers, rulers, compasses, stickers, and other equipment you might need to update the map with hiking trails.

# A trailhead is any position that starts one or more hiking trails - here, these positions will always have height 0. Assembling more fragments of pages, you establish that a trailhead's score is the number of 9-height positions reachable from that trailhead via a hiking trail. In the above example, the single trailhead in the top left corner has a score of 1 because it can reach a single 9 (the one in the bottom left).

# This trailhead has a score of 2:

# ...0...
# ...1...
# ...2...
# 6543456
# 7.....7
# 8.....8
# 9.....9
# (The positions marked . are impassable tiles to simplify these examples; they do not appear on your actual topographic map.)

# This trailhead has a score of 4 because every 9 is reachable via a hiking trail except the one immediately to the left of the trailhead:

# ..90..9
# ...1.98
# ...2..7
# 6543456
# 765.987
# 876....
# 987....
# This topographic map contains two trailheads; the trailhead at the top has a score of 1, while the trailhead at the bottom has a score of 2:

# 10..9..
# 2...8..
# 3...7..
# 4567654
# ...8..3
# ...9..2
# .....01
# Here's a larger example:

# 89010123
# 78121874
# 87430965
# 96549874
# 45678903
# 32019012
# 01329801
# 10456732
# This larger example has 9 trailheads. Considering the trailheads in reading order, they have scores of 5, 6, 5, 3, 1, 3, 5, 3, and 5. Adding these scores together, the sum of the scores of all trailheads is 36.

# The reindeer gleefully carries over a protractor and adds it to the pile. What is the sum of the scores of all trailheads on your topographic map?

input_array = ARGV

def walk_trails(x, y, prev_x, prev_y, topographic_map, path, trailends = {}, debug=false)
  path.push "#{x},#{y}"

  if x < 0 || y < 0 || x >= topographic_map[0].length || y >= topographic_map.length
    return
  end

  if !prev_x.nil? && !prev_y.nil? && (topographic_map[y][x] - topographic_map[prev_y][prev_x]) != 1
    return
  end

  if topographic_map[y][x] == 9 && trailends["#{x},#{y}"].nil?
    trailends["#{x},#{y}"] = path
    return
  end


  walk_trails(x+1, y, x, y, topographic_map, path.dup, trailends, debug)
  walk_trails(x-1, y, x, y, topographic_map, path.dup, trailends, debug)
  walk_trails(x, y+1, x, y, topographic_map, path.dup, trailends, debug)
  walk_trails(x, y-1, x, y, topographic_map, path.dup, trailends, debug)
end

def find_trailhead_scores(topographic_map, trailhead_starts, debug=false)
  scores = 0

  trailhead_starts.each do |trailhead_start|
    trailends = {}
    walk_trails(trailhead_start[:x], trailhead_start[:y], nil, nil, topographic_map, [], trailends, debug)
    puts "#{trailhead_start} => #{trailends.keys}" if debug
    scores += trailends.keys.length
  end

  scores
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

  puts "Sum of the scores of all trailheads: #{find_trailhead_scores(topographic_map, trailhead_starts, debug)}"

end


process(input_array[0], !input_array.at(1).nil?)
