# You find yourselves on the roof of a top-secret Easter Bunny installation.

# While The Historians do their thing, you take a look at the familiar huge antenna. Much to your surprise, it seems to have been reconfigured to emit a signal that makes people 0.1% more likely to buy Easter Bunny brand Imitation Mediocre Chocolate as a Christmas gift! Unthinkable!

# Scanning across the city, you find that there are actually many such antennas. Each antenna is tuned to a specific frequency indicated by a single lowercase letter, uppercase letter, or digit. You create a map (your puzzle input) of these antennas. For example:

# ............
# ........0...
# .....0......
# .......0....
# ....0.......
# ......A.....
# ............
# ............
# ........A...
# .........A..
# ............
# ............
# The signal only applies its nefarious effect at specific antinodes based on the resonant frequencies of the antennas. In particular, an antinode occurs at any point that is perfectly in line with two antennas of the same frequency - but only when one of the antennas is twice as far away as the other. This means that for any pair of antennas with the same frequency, there are two antinodes, one on either side of them.

# So, for these two antennas with frequency a, they create the two antinodes marked with #:

# ..........
# ...#......
# ..........
# ....a.....
# ..........
# .....a....
# ..........
# ......#...
# ..........
# ..........
# Adding a third antenna with the same frequency creates several more antinodes. It would ideally add four antinodes, but two are off the right side of the map, so instead it adds only two:

# ..........
# ...#......
# #.........
# ....a.....
# ........a.
# .....a....
# ..#.......
# ......#...
# ..........
# ..........
# Antennas with different frequencies don't create antinodes; A and a count as different frequencies. However, antinodes can occur at locations that contain antennas. In this diagram, the lone antenna with frequency capital A creates no antinodes but has a lowercase-a-frequency antinode at its location:

# ..........
# ...#......
# #.........
# ....a.....
# ........a.
# .....a....
# ..#.......
# ......A...
# ..........
# ..........
# The first example has antennas with two different frequencies, so the antinodes they create look like this, plus an antinode overlapping the topmost A-frequency antenna:

# ......#....#
# ...#....0...
# ....#0....#.
# ..#....0....
# ....0....#..
# .#....A.....
# ...#........
# #......#....
# ........A...
# .........A..
# ..........#.
# ..........#.
# Because the topmost A-frequency antenna overlaps with a 0-frequency antinode, there are 14 total unique locations that contain an antinode within the bounds of the map.

# Calculate the impact of the signal. How many unique locations within the bounds of the map contain an antinode?

input_array = ARGV

def calculate_antinodes(antennas, width, height)
  antinodes = {}

  antennas.each do |frequency, positions|
    positions.combination(2).each do |pos1, pos2|
      x1 = pos1[:x]
      y1 = pos1[:y]
      x2 = pos2[:x]
      y2 = pos2[:y]

      dx = x2 - x1
      dy = y2 - y1

      # possible antinode positions
      antinode1 = {x: x1 - dx, y: y1 - dy}
      antinode2 = {x: x2 + dx, y: y2 + dy}

      if antinode1[:x].between?(0, width - 1) && antinode1[:y].between?(0, height - 1)
        antinodes[antinode1] = true
      end
      if antinode2[:x].between?(0, width - 1) && antinode2[:y].between?(0, height - 1)
        antinodes[antinode2] = true
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
