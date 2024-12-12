# While The Historians begin working around the guard's patrol route, you borrow their fancy device and step outside the lab. From the safety of a supply closet, you time travel through the last few months and record the nightly status of the lab's guard post on the walls of the closet.

# Returning after what seems like only a few seconds to The Historians, they explain that the guard's patrol area is simply too large for them to safely search the lab without getting caught.

# Fortunately, they are pretty sure that adding a single new obstruction won't cause a time paradox. They'd like to place the new obstruction in such a way that the guard will get stuck in a loop, making the rest of the lab safe to search.

# To have the lowest chance of creating a time paradox, The Historians would like to know all of the possible positions for such an obstruction. The new obstruction can't be placed at the guard's starting position - the guard is there right now and would notice.

# In the above example, there are only 6 different positions where a new obstruction would cause the guard to get stuck in a loop. The diagrams of these six situations use O to mark the new obstruction, | to show a position where the guard moves up/down, - to show a position where the guard moves left/right, and + to show a position where the guard moves both up/down and left/right.

# Option one, put a printing press next to the guard's starting position:

# ....#.....
# ....+---+#
# ....|...|.
# ..#.|...|.
# ....|..#|.
# ....|...|.
# .#.O^---+.
# ........#.
# #.........
# ......#...
# Option two, put a stack of failed suit prototypes in the bottom right quadrant of the mapped area:


# ....#.....
# ....+---+#
# ....|...|.
# ..#.|...|.
# ..+-+-+#|.
# ..|.|.|.|.
# .#+-^-+-+.
# ......O.#.
# #.........
# ......#...
# Option three, put a crate of chimney-squeeze prototype fabric next to the standing desk in the bottom right quadrant:

# ....#.....
# ....+---+#
# ....|...|.
# ..#.|...|.
# ..+-+-+#|.
# ..|.|.|.|.
# .#+-^-+-+.
# .+----+O#.
# #+----+...
# ......#...
# Option four, put an alchemical retroencabulator near the bottom left corner:

# ....#.....
# ....+---+#
# ....|...|.
# ..#.|...|.
# ..+-+-+#|.
# ..|.|.|.|.
# .#+-^-+-+.
# ..|...|.#.
# #O+---+...
# ......#...
# Option five, put the alchemical retroencabulator a bit to the right instead:

# ....#.....
# ....+---+#
# ....|...|.
# ..#.|...|.
# ..+-+-+#|.
# ..|.|.|.|.
# .#+-^-+-+.
# ....|.|.#.
# #..O+-+...
# ......#...
# Option six, put a tank of sovereign glue right next to the tank of universal solvent:

# ....#.....
# ....+---+#
# ....|...|.
# ..#.|...|.
# ..+-+-+#|.
# ..|.|.|.|.
# .#+-^-+-+.
# .+----++#.
# #+----++..
# ......#O..
# It doesn't really matter what you choose to use as an obstacle so long as you and The Historians can put it into position without the guard noticing. The important thing is having enough options that you can find one that minimizes time paradoxes, and in this example, there are 6 different positions you could choose.

# You need to get the guard stuck in a loop by adding a single new obstruction. How many different positions could you choose for this obstruction?

input_array = ARGV

def position_string(position)
  "#{position[:x]}|#{position[:y]}|#{position[:direction]}"
end

def is_barrier?(character)
  character == '#'
end

def guard_walk(map, start_position)
  current_position = start_position
  visited_positions = []
  visited_positions.push(position_string(current_position))
  cycle_found = false

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

    if visited_positions.include?(position_string(current_position))
      cycle_found = true
      break
    else
      visited_positions.push(position_string(current_position))
    end
  end

  {
    visited_positions: visited_positions,
    cycle_found: cycle_found,
  }
end

def possible_cycle_count(map, start_position)
  cycle_count = 0
  row_count = map.count
  column_count = map[0].count

  initial_walk = guard_walk(map, start_position)

  visited_positions = initial_walk[:visited_positions]
  unique_visited_positions = visited_positions.uniq do |position|
    position_parts = position.split("|")
    column = position_parts[0].to_i
    row = position_parts[1].to_i
    "#{row}|#{column}"
  end

  puts "Visited: #{visited_positions.count}"
  puts "Unique Visited: #{unique_visited_positions.count}"

  unique_visited_positions.each.with_index do |position, index|
    position_parts = position.split("|")
    column = position_parts[0].to_i
    row = position_parts[1].to_i

    if map[row][column] == '.'
      map[row][column] = '#'
      walk = guard_walk(map, start_position)
      cycle_count += 1 if walk[:cycle_found]

      puts "[#{index+1}] Obstruction added at: #{row}, #{column}, cycle found: #{walk[:cycle_found]}"

      # reset map
      map[row][column] = '.'
    else
      puts "[#{index+1}] Obstruction or starting point already exists at: #{row}, #{column}"
    end
  end

  cycle_count
end

def process(file_name)
  map = []
  guard_start_position = {x: 0, y: 0, direction: '^'}

  File.foreach(ARGV[0]).with_index do |line, row_index|
    row = line.strip.chars
    column_index = row.index('^')
    if !column_index.nil?
      guard_start_position = {x: column_index, y: row_index, direction: row[column_index]}
    end
    map.push(row)
  end

  puts "Guard start position: #{guard_start_position}, map: #{map[guard_start_position[:y]][guard_start_position[:x]]}"
  puts "Possible cycle count: #{possible_cycle_count(map, guard_start_position)}"

end


process(input_array[0])
