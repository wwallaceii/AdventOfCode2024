# As The Historians wander around a secure area at Easter Bunny HQ, you come across posters for a LAN party scheduled for today! Maybe you can find it; you connect to a nearby datalink port and download a map of the local network (your puzzle input).

# The network map provides a list of every connection between two computers. For example:

# kh-tc
# qp-kh
# de-cg
# ka-co
# yn-aq
# qp-ub
# cg-tb
# vc-aq
# tb-ka
# wh-tc
# yn-cg
# kh-ub
# ta-co
# de-co
# tc-td
# tb-wq
# wh-td
# ta-ka
# td-qp
# aq-cg
# wq-ub
# ub-vc
# de-ta
# wq-aq
# wq-vc
# wh-yn
# ka-de
# kh-ta
# co-tc
# wh-qp
# tb-vc
# td-yn
# Each line of text in the network map represents a single connection; the line kh-tc represents a connection between the computer named kh and the computer named tc. Connections aren't directional; tc-kh would mean exactly the same thing.

# LAN parties typically involve multiplayer games, so maybe you can locate it by finding groups of connected computers. Start by looking for sets of three computers where each computer in the set is connected to the other two computers.

# In this example, there are 12 such sets of three inter-connected computers:

# aq,cg,yn
# aq,vc,wq
# co,de,ka
# co,de,ta
# co,ka,ta
# de,ka,ta
# kh,qp,ub
# qp,td,wh
# tb,vc,wq
# tc,td,wh
# td,wh,yn
# ub,vc,wq
# If the Chief Historian is here, and he's at the LAN party, it would be best to know that right away. You're pretty sure his computer's name starts with t, so consider only sets of three computers where at least one computer's name starts with t. That narrows the list down to 7 sets of three inter-connected computers:

# co,de,ta
# co,ka,ta
# de,ka,ta
# qp,td,wh
# tb,vc,wq
# tc,td,wh
# td,wh,yn
# Find all the sets of three inter-connected computers. How many contain at least one computer with a name that starts with t?
input_array = ARGV

def find_three_connected_computers(adjacency_list)
  three_connected_computers = []
  adjacency_list.each do |computer, connections|
    next if !computer.start_with?('t') && !connections.any? {|connection| connection.start_with?('t')}
    connections.each do |connection|
      adjacency_list[connection].each do |connection2|
        if connections.include?(connection2)
            connected_computers = [computer, connection, connection2].sort
          three_connected_computers.push(connected_computers) unless three_connected_computers.include?(connected_computers)
        end
      end
    end
  end
  three_connected_computers
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
  
  three_connected_computers = find_three_connected_computers(adjacency_list)
  puts "Three connected computers: #{three_connected_computers}" if debug
  t_networks = three_connected_computers.select {|network| network.any? {|computer| computer.start_with?('t')}}
  puts "Three connected computers count with 't': #{t_networks.length}"
end


process(input_array[0], !input_array.at(1).nil?)

