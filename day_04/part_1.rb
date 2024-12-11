# "Looks like the Chief's not here. Next!" One of The Historians pulls out a device and pushes the only button on it. After a brief flash, you recognize the interior of the Ceres monitoring station!

# As the search for the Chief continues, a small Elf who lives on the station tugs on your shirt; she'd like to know if you could help her with her word search (your puzzle input). She only has to find one word: XMAS.

# This word search allows words to be horizontal, vertical, diagonal, written backwards, or even overlapping other words. It's a little unusual, though, as you don't merely need to find one instance of XMAS - you need to find all of them. Here are a few ways XMAS might appear, where irrelevant characters have been replaced with .:


# ..X...
# .SAMX.
# .A..A.
# XMAS.S
# .X....
# The actual word search will be full of letters instead. For example:

# MMMSXXMASM
# MSAMXMSMSA
# AMXSXMAAMM
# MSAMASMSMX
# XMASAMXAMM
# XXAMMXXAMA
# SMSMSASXSS
# SAXAMASAAA
# MAMMMXMMMM
# MXMXAXMASX
# In this word search, XMAS occurs a total of 18 times; here's the same word search again, but where letters not involved in any XMAS have been replaced with .:

# ....XXMAS.
# .SAMXMS...
# ...S..A...
# ..A.A.MS.X
# XMASAMX.MM
# X.....XA.A
# S.S.S.S.SS
# .A.A.A.A.A
# ..M.M.M.MM
# .X.X.XMASX
# Take a look at the little Elf's word search. How many times does XMAS appear?

input_array = ARGV

def is_valid_coordinates?(x,y, size_x, size_y)
  return 0 <= x && x < size_x && 0 <= y && y < size_y
end

def find_word_in_direction(grid, rows, columns, word, index, x, y, direction_x, direction_y)
  return true if index == word.length
  return false if !is_valid_coordinates?(x, y, rows, columns) || grid[x][y] != word[index]

  return find_word_in_direction(grid, rows, columns, word, index + 1, x + direction_x, y + direction_y, direction_x, direction_y)
end

def find_word(grid, word)
  count = 0
  # Directions for 8 possible movements
  directions = [{x: 1, y: 0}, {x: -1, y: 0}, {x: 0, y: 1}, {x: 0, y: -1}, {x: 1, y: 1}, {x: 1, y: -1}, {x: -1, y: 1}, {x: -1, y: -1}]
  rows = grid.count
  columns = grid[0].count
  (0...rows).each do |x|
    (0...columns).each do |y|
      (0...directions.count).each do |i|
        count += 1 if find_word_in_direction(grid, rows, columns, word, 0, x, y, directions[i][:x], directions[i][:y])
      end
    end
  end
  count
end

# Read the input file
def process(file_name)
  search_board = []

  File.foreach(ARGV[0]).with_index do |row|
    items = row.chars
    search_board.push(items)
  end

  count = find_word(search_board, "XMAS")
  puts "XMAS appearances: #{count}"
end

process(input_array[0])
