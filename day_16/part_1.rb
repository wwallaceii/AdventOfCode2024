# It's time again for the Reindeer Olympics! This year, the big event is the Reindeer Maze, where the Reindeer compete for the lowest score.

# You and The Historians arrive to search for the Chief right as the event is about to start. It wouldn't hurt to watch a little, right?

# The Reindeer start on the Start Tile (marked S) facing East and need to reach the End Tile (marked E). They can move forward one tile at a time (increasing their score by 1 point), but never into a wall (#). They can also rotate clockwise or counterclockwise 90 degrees at a time (increasing their score by 1000 points).

# To figure out the best place to sit, you start by grabbing a map (your puzzle input) from a nearby kiosk. For example:

# ###############
# #.......#....E#
# #.#.###.#.###.#
# #.....#.#...#.#
# #.###.#####.#.#
# #.#.#.......#.#
# #.#.#####.###.#
# #...........#.#
# ###.#.#####.#.#
# #...#.....#.#.#
# #.#.#.###.#.#.#
# #.....#...#.#.#
# #.###.#.#.#.#.#
# #S..#.....#...#
# ###############
# There are many paths through this maze, but taking any of the best paths would incur a score of only 7036. This can be achieved by taking a total of 36 steps forward and turning 90 degrees a total of 7 times:


# ###############
# #.......#....E#
# #.#.###.#.###^#
# #.....#.#...#^#
# #.###.#####.#^#
# #.#.#.......#^#
# #.#.#####.###^#
# #..>>>>>>>>v#^#
# ###^#.#####v#^#
# #>>^#.....#v#^#
# #^#.#.###.#v#^#
# #^....#...#v#^#
# #^###.#.#.#v#^#
# #S..#.....#>>^#
# ###############
# Here's a second example:

# #################
# #...#...#...#..E#
# #.#.#.#.#.#.#.#.#
# #.#.#.#...#...#.#
# #.#.#.#.###.#.#.#
# #...#.#.#.....#.#
# #.#.#.#.#.#####.#
# #.#...#.#.#.....#
# #.#.#####.#.###.#
# #.#.#.......#...#
# #.#.###.#####.###
# #.#.#...#.....#.#
# #.#.#.#####.###.#
# #.#.#.........#.#
# #.#.#.#########.#
# #S#.............#
# #################
# In this maze, the best paths cost 11048 points; following one such path would look like this:

# #################
# #...#...#...#..E#
# #.#.#.#.#.#.#.#^#
# #.#.#.#...#...#^#
# #.#.#.#.###.#.#^#
# #>>v#.#.#.....#^#
# #^#v#.#.#.#####^#
# #^#v..#.#.#>>>>^#
# #^#v#####.#^###.#
# #^#v#..>>>>^#...#
# #^#v###^#####.###
# #^#v#>>^#.....#.#
# #^#v#^#####.###.#
# #^#v#^........#.#
# #^#v#^#########.#
# #S#>>^..........#
# #################
# Note that the path shown above includes one 90 degree turn as the very first move, rotating the Reindeer from facing East to facing North.

# Analyze your map carefully. What is the lowest score a Reindeer could possibly get?
input_array = ARGV

def turn_clockwise(dir)
  if dir == '>'
    return 'v'
  elsif dir == 'v'
    return '<'
  elsif dir == '<'
    return '^'
  elsif dir == '^'
    return '>'
  end
end

def turn_counter_clockwise(dir)
  if dir == '>'
    return '^'
  elsif dir == 'v'
    return '>'
  elsif dir == '<'
    return 'v'
  elsif dir == '^'
    return '<'
  end
end

def move_distances(dir)
  if dir == '>'
    return { x: 1, y: 0 }
  elsif dir == 'v'
    return { x: 0, y: 1 }
  elsif dir == '<'
    return { x: -1, y: 0 }
  elsif dir == '^'
    return { x: 0, y: -1 }
  end
end

def opposite_direction(dir)
  if dir == '>'
    return '<'
  elsif dir == 'v'
    return '^'
  elsif dir == '<'
    return '>'
  elsif dir == '^'
    return 'v'
  end
end

def walk_maze(maze_points, maze_map,debug=false)

  maze_start = maze_points[:start]
  maze_end = maze_points[:end]
  queue = [{ x: maze_start[:x], y: maze_start[:y], direction: maze_start[:dir], score: 0, turns: 0 }]
  visited = {}

  min_score = Float::INFINITY
  scores = []
  while !queue.empty?
    # puts "queue: #{queue.join(", ")}"
    current = queue.shift
    x = current[:x]
    y = current[:y]
    direction = current[:direction]
    score = current[:score]
    turns = current[:turns]

    if x == maze_end[:x] && y == maze_end[:y]
      scores << score
      next
    end

    visited["#{x},#{y},#{direction}"] = true

    move = move_distances(direction)
    next_x = x + move[:x]
    next_y = y + move[:y]

    # forward move
    if next_x >= 0 && next_x < maze_map[0].length &&  next_y >= 0 && next_y < maze_map.length &&
      maze_map[next_y][next_x] != '#' && !visited["#{next_x},#{next_y},#{direction}"] && !visited["#{next_x},#{next_y},#{opposite_direction(direction)}"]
      queue.push({ x: next_x, y: next_y, direction: direction, score: score + 1, turns: turns })
    end

    # clockwise
    clockwise_direction = turn_clockwise(direction)
    if !visited["#{x},#{y},#{clockwise_direction}"]
      queue.push({ x: x, y: y, direction: clockwise_direction, score: score + 1000, turns: turns + 1 })
    end

    # counter clockwise
    ccw_direction = turn_counter_clockwise(direction)
    if !visited["#{x},#{y},#{ccw_direction}"]
      queue.push({ x: x, y: y, direction: ccw_direction, score: score + 1000, turns: turns + 1 })
    end

    queue.sort_by! { |q| q[:score] }
  end

  scores.min
end

def find_maze_scores(maze_map, maze_points, debug=false)
  walk_maze(maze_points, maze_map, debug)
end

def process(file_name, debug=false)

  maze_map = []
  maze_points = {
    start: nil,
    end: nil
  }

  File.foreach(ARGV[0]).with_index do |line, index|
    row = line.strip.chars
    row.each_index.select { |i| row[i] == 'S' || row[i] == 'E' }.each do |i|
      maze_points[:start] = { x: i, y: index, dir: '>' } if row[i] == 'S'
      maze_points[:end] = { x: i, y: index } if row[i] == 'E'
    end
    maze_map.push(row)
  end

  if debug
    puts "maze_map:"
    maze_map.each do |row|
      puts row.join
    end
    puts "Race start/end: #{maze_points}}"
  end

  puts "Lowest score: #{find_maze_scores(maze_map, maze_points, debug)}"
end


process(input_array[0], !input_array.at(1).nil?)
