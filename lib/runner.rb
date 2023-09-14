require './spec/spec_helper'

def place_ship(board, ship)
  coordinates = []
  loop do
    coordinates = gets.chomp.split("\s")
    break if board.valid_placement?(ship, coordinates) # .split("\s"))
    puts "Those are invalid coordinates. Please try again:"
  end
  board.place(ship, coordinates)
  board.render(true)
end

puts "Welcome to BATTLESHIP\nEnter p to play. Enter q to quit."

loop do
  p_or_q = gets.chomp

  if p_or_q == "p"
    break
  elsif p_or_q == "q"
    exit
  end

  puts "Invalid response. Enter p to play. Enter q to quit."
end

cruiser = Ship.new("Cruiser", 3)
submarine = Ship.new("Submarine", 2)

computer = Board.new
player = Board.new

puts "\nI have laid out my ships on the grid.\n" +
"You now need to lay out your two ships.\n" + 
"The Cruiser is three units long and the Submarine is two units long."
player.render

puts "\nEnter the squares for the Cruiser (3 spaces):"
place_ship(player, cruiser)

puts "\nEnter the squares for the Submarine (2 spaces):"
place_ship(player, submarine)