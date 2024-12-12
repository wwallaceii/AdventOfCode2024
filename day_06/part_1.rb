# The Historians use their fancy device again, this time to whisk you all away to the North Pole prototype suit manufacturing lab... in the year 1518! It turns out that having direct access to history is very convenient for a group of historians.

# You still have to be careful of time paradoxes, and so it will be important to avoid anyone from 1518 while The Historians search for the Chief. Unfortunately, a single guard is patrolling this part of the lab.

# Maybe you can work out where the guard will go ahead of time so that The Historians can search safely?

# You start by making a map (your puzzle input) of the situation. For example:

# ....#.....
# .........#
# ..........
# ..#.......
# .......#..
# ..........
# .#..^.....
# ........#.
# #.........
# ......#...
# The map shows the current position of the guard with ^ (to indicate the guard is currently facing up from the perspective of the map). Any obstructions - crates, desks, alchemical reactors, etc. - are shown as #.

# Lab guards in 1518 follow a very strict patrol protocol which involves repeatedly following these steps:

# If there is something directly in front of you, turn right 90 degrees.
# Otherwise, take a step forward.
# Following the above protocol, the guard moves up several times until she reaches an obstacle (in this case, a pile of failed suit prototypes):

# ....#.....
# ....^....#
# ..........
# ..#.......
# .......#..
# ..........
# .#........
# ........#.
# #.........
# ......#...
# Because there is now an obstacle in front of the guard, she turns right before continuing straight in her new facing direction:

# ....#.....
# ........>#
# ..........
# ..#.......
# .......#..
# ..........
# .#........
# ........#.
# #.........
# ......#...
# Reaching another obstacle (a spool of several very long polymers), she turns right again and continues downward:

# ....#.....
# .........#
# ..........
# ..#.......
# .......#..
# ..........
# .#......v.
# ........#.
# #.........
# ......#...
# This process continues for a while, but the guard eventually leaves the mapped area (after walking past a tank of universal solvent):

# ....#.....
# .........#
# ..........
# ..#.......
# .......#..
# ..........
# .#........
# ........#.
# #.........
# ......#v..
# By predicting the guard's route, you can determine which specific positions in the lab will be in the patrol path. Including the guard's starting position, the positions visited by the guard before leaving the area are marked with an X:

# ....#.....
# ....XXXXX#
# ....X...X.
# ..#.X...X.
# ..XXXXX#X.
# ..X.X.X.X.
# .#XXXXXXX.
# .XXXXXXX#.
# #XXXXXXX..
# ......#X..
# In this example, the guard will visit 41 distinct positions on your map.

# Predict the path of the guard. How many distinct positions will the guard visit before leaving the mapped area?

input_array = ARGV

def guard_walk(map, start_position)
  current_position = start_position
  visited_positions = []
  visited_positions.push(current_position)
  while true
    x = current_position[:x]
    y = current_position[:y]
    direction = current_position[:direction]
    if direction == '^'
      break if (y-1) < 0
      if map[y - 1][x] == '#'
        direction = '>'
      else
        y -= 1
      end
    elsif direction == '>'
      break if (x+1) == map[y].count
      if map[y][x + 1] == '#'
        direction = 'v'
      else
        x += 1
      end
    elsif direction == 'v'
      break if (y+1) == map.count
      if map[y + 1][x] == '#'
        direction = '<'
      else
        y += 1
      end
    elsif direction == '<'
      break if (x-1) < 0
      if map[y][x - 1] == '#'
        direction = '^'
      else
        x -= 1
      end
    end

    current_position = {x: x, y: y, direction: direction}
    visited_positions.push(current_position)
    break if visited_positions.uniq.count != visited_positions.count
  end
  visited_positions.uniq! { |position| "#{position[:x]}-#{position[:y]}" }
  visited_positions
end

def process(file_name)
  map = []
  guard_start_position = {x: 0, y: 0, direction: '^'}

  File.foreach(ARGV[0]).with_index do |line, index|
    row = line.strip.chars
    guard_index = row.index('^')
    if !guard_index.nil?
      guard_start_position = {x: guard_index, y: index, direction: row[guard_index]}
    end
    map.push(row)
  end

  puts "Guard start position: #{guard_start_position}"
  puts "Map:"
  map.each do |row|
    puts "#{row.join}"
  end

  puts "Visited positions: #{guard_walk(map, guard_start_position).count}"

end


process(input_array[0])
