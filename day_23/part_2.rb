# There are still way too many results to go through them all. You'll have to find the LAN party another way and go there yourself.

# Since it doesn't seem like any employees are around, you figure they must all be at the LAN party. If that's true, the LAN party will be the largest set of computers that are all connected to each other. That is, for each computer at the LAN party, that computer will have a connection to every other computer at the LAN party.

# In the above example, the largest set of computers that are all connected to each other is made up of co, de, ka, and ta. Each computer in this set has a connection to every other computer in the set:

# ka-co
# ta-co
# de-co
# ta-ka
# de-ta
# ka-de
# The LAN party posters say that the password to get into the LAN party is the name of every computer at the LAN party, sorted alphabetically, then joined together with commas. (The people running the LAN party are clearly a bunch of nerds.) In this example, the password would be co,de,ka,ta.

# What is the password to get into the LAN party?
input_array = ARGV

def find_largest_lan_party(adjacency_list)
  largest_lan_party = []

  adjacency_list.each do |computer, connections|
    lan_party = [computer]
    connections.each do |connection|
      all_connected = lan_party.all? { |lan_party_computer| adjacency_list[connection].include?(lan_party_computer) }
      lan_party.push(connection) if all_connected
    end
    largest_lan_party = lan_party if lan_party.length > largest_lan_party.length
  end

  puts "Largest LAN party: #{largest_lan_party}"
  password = largest_lan_party.sort.join(',')
  puts "Password: #{password}"
end

def process(file_name, debug=false)
  adjacency_list = {}
  File.foreach(ARGV[0]).with_index do |line, index|
    row = line.strip.split('-')
    node1 = row[0]
    node2 = row[1]
    adjacency_list[node1] = [] if adjacency_list[node1].nil?
    adjacency_list[node1].push(node2)
    adjacency_list[node2] = [] if adjacency_list[node2].nil?
    adjacency_list[node2].push(node1)
  end

  puts "Adjacency list: #{adjacency_list}" if debug
  
  find_largest_lan_party(adjacency_list)
end


process(input_array[0], !input_array.at(1).nil?)

