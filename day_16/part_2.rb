# Now that you know what the best paths look like, you can figure out the best spot to sit.

# Every non-wall tile (S, ., or E) is equipped with places to sit along the edges of the tile. While determining which of these tiles would be the best spot to sit depends on a whole bunch of factors (how comfortable the seats are, how far away the bathrooms are, whether there's a pillar blocking your view, etc.), the most important factor is whether the tile is on one of the best paths through the maze. If you sit somewhere else, you'd miss all the action!

# So, you'll need to determine which tiles are part of any best path through the maze, including the S and E tiles.

# In the first example, there are 45 tiles (marked O) that are part of at least one of the various best paths through the maze:

# ###############
# #.......#....O#
# #.#.###.#.###O#
# #.....#.#...#O#
# #.###.#####.#O#
# #.#.#.......#O#
# #.#.#####.###O#
# #..OOOOOOOOO#O#
# ###O#O#####O#O#
# #OOO#O....#O#O#
# #O#O#O###.#O#O#
# #OOOOO#...#O#O#
# #O###.#.#.#O#O#
# #O..#.....#OOO#
# ###############
# In the second example, there are 64 tiles that are part of at least one of the best paths:

# #################
# #...#...#...#..O#
# #.#.#.#.#.#.#.#O#
# #.#.#.#...#...#O#
# #.#.#.#.###.#.#O#
# #OOO#.#.#.....#O#
# #O#O#.#.#.#####O#
# #O#O..#.#.#OOOOO#
# #O#O#####.#O###O#
# #O#O#..OOOOO#OOO#
# #O#O###O#####O###
# #O#O#OOO#..OOO#.#
# #O#O#O#####O###.#
# #O#O#OOOOOOO..#.#
# #O#O#O#########.#
# #O#OOO..........#
# #################
# Analyze your map further. How many tiles are part of at least one of the best paths through the maze?
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
  queue = [{ x: maze_start[:x], y: maze_start[:y], direction: maze_start[:dir], score: 0, turns: 0, path: [] }]
  visited = {}

  min_score = Float::INFINITY
  scores = []
  min_paths = []
  while !queue.empty?
    current = queue.shift
    x = current[:x]
    y = current[:y]
    direction = current[:direction]
    score = current[:score]
    turns = current[:turns]
    path = current[:path]

    path.push("#{x},#{y},#{direction}")

    if x == maze_end[:x] && y == maze_end[:y]
      if score < min_score
        min_paths = [path]
        min_score = score
      elsif score == min_score
        min_paths << path
      end

      next
    end

    visited["#{x},#{y},#{direction}"] = true

    move = move_distances(direction)
    next_x = x + move[:x]
    next_y = y + move[:y]

    # forward move
    if next_x >= 0 && next_x < maze_map[0].length &&  next_y >= 0 && next_y < maze_map.length &&
      maze_map[next_y][next_x] != '#' && !visited["#{next_x},#{next_y},#{direction}"]
      queue.push({ x: next_x, y: next_y, direction: direction, score: score + 1, turns: turns, path: path.dup })
    end

    # clockwise
    clockwise_direction = turn_clockwise(direction)
    if !visited["#{x},#{y},#{clockwise_direction}"]
      queue.push({ x: x, y: y, direction: clockwise_direction, score: score + 1000, turns: turns + 1, path: path.dup })
    end

    # counter clockwise
    ccw_direction = turn_counter_clockwise(direction)
    if !visited["#{x},#{y},#{ccw_direction}"]
      queue.push({ x: x, y: y, direction: ccw_direction, score: score + 1000, turns: turns + 1, path: path.dup })
    end

    queue.sort_by! { |q| q[:score] }
  end

  [min_score, min_paths]
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
  end

  puts "Race start/end: #{maze_points}}"
  maze_run = find_maze_scores(maze_map, maze_points, debug)
  puts "Lowest score: #{maze_run[0]}"

  unique_tiles = {}
  maze_run[1].each do |path|
    path.each do |position|
      pos = position.split(",")
      unique_tiles["#{pos[1]},#{pos[0]}"] = true
    end
  end

  puts "Unique tiles: #{unique_tiles.keys.length}"
end


process(input_array[0], !input_array.at(1).nil?)
