# The Elf looks quizzically at you. Did you misunderstand the assignment?

# Looking for the instructions, you flip over the word search to find that this isn't actually an XMAS puzzle; it's an X-MAS puzzle in which you're supposed to find two MAS in the shape of an X. One way to achieve that is like this:

# M.S
# .A.
# M.S
# Irrelevant characters have again been replaced with . in the above diagram. Within the X, each MAS can be written forwards or backwards.

# Here's the same example from before, but this time all of the X-MASes have been kept instead:

# .M.S......
# ..A..MSMS.
# .M.S.MAA..
# ..A.ASMSM.
# .M.S.M....
# ..........
# S.S.S.S.S.
# .A.A.A.A..
# M.M.M.M.M.
# ..........
# In this example, an X-MAS appears 9 times.

# Flip the word search from the instructions back over to the word search side and try again. How many times does an X-MAS appear?

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
  # Directions for 4 possible movements for X diagonals
  directions = [{x: 1, y: 1}, {x: -1, y: 1}, {x: -1, y: -1}, {x: 1, y: -1}]
  rows = grid.count
  columns = grid[0].count
  found_words = []
  (0...rows).each do |x|
    (0...columns).each do |y|
      (0...directions.count).each do |i|
        found = find_word_in_direction(grid, rows, columns, word, 0, x, y, directions[i][:x], directions[i][:y])
        found_words << {
          x: x,
          y: y,
          direction_x: directions[i][:x],
          direction_y: directions[i][:y]
        } if found
      end
    end
  end

  # find overlapping words
  grouped = found_words.group_by { |h| "(#{h[:x] + h[:direction_x]}, #{h[:y] + h[:direction_y]})" }
  grouped.select { |k, v| v.count % 2 == 0 }.keys.count
  #count
end

# Read the input file
def process(file_name)
  search_board = []

  File.foreach(ARGV[0]).with_index do |row|
    items = row.chars
    search_board.push(items)
  end

  count = find_word(search_board, "MAS")
  puts "MAS appearances: #{count}"
end

process(input_array[0])
