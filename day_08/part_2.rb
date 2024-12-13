# Watching over your shoulder as you work, one of The Historians asks if you took the effects of resonant harmonics into your calculations.

# Whoops!

# After updating your model, it turns out that an antinode occurs at any grid position exactly in line with at least two antennas of the same frequency, regardless of distance. This means that some of the new antinodes will occur at the position of each antenna (unless that antenna is the only one of its frequency).

# So, these three T-frequency antennas now create many antinodes:

# T....#....
# ...T......
# .T....#...
# .........#
# ..#.......
# ..........
# ...#......
# ..........
# ....#.....
# ..........
# In fact, the three T-frequency antennas are all exactly in line with two antennas, so they are all also antinodes! This brings the total number of antinodes in the above example to 9.

# The original example now has 34 antinodes, including the antinodes that appear on every antenna:

# ##....#....#
# .#.#....0...
# ..#.#0....#.
# ..##...0....
# ....0....#..
# .#...#A....#
# ...#..#.....
# #....#.#....
# ..#.....A...
# ....#....A..
# .#........#.
# ...#......##
# Calculate the impact of the signal using this updated model. How many unique locations within the bounds of the map contain an antinode?

input_array = ARGV

def calculate_antinodes(antennas, width, height)
  antinodes = {}

  antennas.each do |frequency, positions|
    positions.combination(2).each do |pos1, pos2|
      antinodes[pos1] = true
      antinodes[pos2] = true

      antinode1_off_grid, antinode2_off_grid = false

      x1 = pos1[:x]
      y1 = pos1[:y]
      x2 = pos2[:x]
      y2 = pos2[:y]


      dx = x2 - x1
      dy = y2 - y1

      while !antinode1_off_grid || !antinode2_off_grid
        # possible antinode positions
        antinode1 = {x: x1 - dx, y: y1 - dy}
        antinode2 = {x: x2 + dx, y: y2 + dy}

        if antinode1[:x].between?(0, width - 1) && antinode1[:y].between?(0, height - 1)
          antinodes[antinode1] = true
          x1 = antinode1[:x]
          y1 = antinode1[:y]
        else
          antinode1_off_grid = true
        end
        if antinode2[:x].between?(0, width - 1) && antinode2[:y].between?(0, height - 1)
          antinodes[antinode2] = true
          x2 = antinode2[:x]
          y2 = antinode2[:y]
        else
          antinode2_off_grid = true
        end
      end
    end
  end
  antinodes
end

def letter?(lookAhead)
  lookAhead.match?(/[[:alpha:]]/)
end

def numeric?(lookAhead)
  lookAhead.match?(/[[:digit:]]/)
end

def process(file_name)
  anntena_map = {
    width: 0,
    height: 0,
  }
  antenna_locations = {}
  rows = 0
  File.foreach(ARGV[0]).with_index do |line, index|
    line_items = line.strip.chars

    if anntena_map[:width] == 0
      anntena_map[:width] = line_items.count
    end

    line_items.each_with_index do |item, i|
      if letter?(item) || numeric?(item)
        antenna_locations[item] = [] if antenna_locations[item].nil?
        antenna_locations[item].push({x: i, y: index})
      end
    end

    rows += 1
  end
  anntena_map[:height] = rows

  puts "Antenna map: height: #{anntena_map[:height]}, width: #{anntena_map[:width]}"
  puts "Antenna locations:"
  antenna_locations.each do |key, value|
    puts "#{key}: #{value.join(", ")}"
  end

  puts "Antinodes:"
  antinodes = calculate_antinodes(antenna_locations, anntena_map[:width], anntena_map[:height])
  puts "#{antinodes.keys.count}"
end


process(input_array[0])
