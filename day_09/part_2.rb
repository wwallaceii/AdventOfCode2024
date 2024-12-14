# Upon completion, two things immediately become clear. First, the disk definitely has a lot more contiguous free space, just like the amphipod hoped. Second, the computer is running much more slowly! Maybe introducing all of that file system fragmentation was a bad idea?

# The eager amphipod already has a new plan: rather than move individual blocks, he'd like to try compacting the files on his disk by moving whole files instead.

# This time, attempt to move whole files to the leftmost span of free space blocks that could fit the file. Attempt to move each file exactly once in order of decreasing file ID number starting with the file with the highest file ID number. If there is no span of free space to the left of a file that is large enough to fit the file, the file does not move.

# The first example from above now proceeds differently:

# 00...111...2...333.44.5555.6666.777.888899
# 0099.111...2...333.44.5555.6666.777.8888..
# 0099.1117772...333.44.5555.6666.....8888..
# 0099.111777244.333....5555.6666.....8888..
# 00992111777.44.333....5555.6666.....8888..
# The process of updating the filesystem checksum is the same; now, this example's checksum would be 2858.

# Start over, now compacting the amphipod's hard drive using this new method instead. What is the resulting filesystem checksum?

input_array = ARGV

def create_file_system_map(disk_map)
  file_system_map = []

  next_id = 0
  file_block = true
  disk_map.each do |file|
    if file_block
      file_block = false
      file.to_i.times do
        file_system_map.push(next_id.to_s)
      end
      next_id += 1
    else
      file_block = true
      file.to_i.times do
        file_system_map.push(".")
      end
    end
  end

  return file_system_map
end

def compact_disk(file_system_map, debug=false)
  free_space_index = file_system_map.index(".")
  blocks = []
  end_index = file_system_map.rindex { |block| block != "." }

  while !end_index.nil?
    start_block_index = end_index

    if file_system_map[start_block_index] != "."
      while file_system_map[start_block_index] != "." && file_system_map[start_block_index-1] == file_system_map[end_index]
        start_block_index -= 1
      end

      block_size = end_index - start_block_index + 1
      blocks.push(
        {
          block_array: file_system_map[start_block_index, block_size],
          start_index: start_block_index,
          block_size: block_size
        }
      ) if file_system_map[start_block_index] != "."
    end

    end_index = file_system_map[0, start_block_index + 1].rindex { |block| block != "." && block != file_system_map[end_index] }
  end

  puts "blocks: #{blocks}" if debug

  blocks.each do |block|

    file_system_map.each_cons(block[:block_size]).with_index do |file_block, index|
      if index < block[:start_index] && file_block.all? { |b| b == "." }
        file_system_map[index, block[:block_size]] = block[:block_array]
        puts "block_array: #{block[:block_array]}, start_index: #{file_system_map[block[:start_index], block[:block_size]]}, block: #{block}" if debug

        file_system_map[block[:start_index], block[:block_size]] = Array.new(block[:block_size], ".")

        puts "filesystem map: #{file_system_map.join("")}" if debug
        break
      end
    end
  end

  file_system_map
end

def file_checksum(file_system_map)
  checksum = 0
  file_system_map.each_with_index do |block, index|
    checksum += block.to_i * index if block != "."
  end
  checksum
end

def process(file_name, debug=false)

  disk_map = nil
  File.foreach(ARGV[0]).with_index do |line, index|
    disk_map = line.strip.chars
  end


  file_system_map = create_file_system_map(disk_map)
  compact_map = compact_disk(file_system_map, debug)

  puts "Disk map: #{disk_map.join}" if debug
  puts "file_system_map: #{file_system_map.join}" if debug
  puts "compact_map: #{compact_map.join}" if debug

  puts "Checksum: #{file_checksum(compact_map)}"
end


process(input_array[0], !input_array.at(1).nil?)
