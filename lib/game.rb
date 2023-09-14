
class Game
  attr_reader :boards

  def initialize()
    @boards = {}
    start_game
  end

  def start_game
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
    set_up_game
  end

  def set_up_game
    @boards[:computer] = Board.new
    @boards[:player] = Board.new

    ships = [
      Ship.new("Cruiser", 3),
      Ship.new("Submarine", 2)
    ]

    set_up_computer_board([Ship.new("Cruiser", 3), Ship.new("Submarine", 2)])

    puts "\nI have laid out my ships on the grid.\n" +
    "You now need to lay out your two ships.\n" + 
    "The Cruiser is three units long and the Submarine is two units long."
    @boards[:player].render

    ships.each { |ship| place_ship(@boards[:player], ship) }
    require 'pry'; binding.pry
  end

  def set_up_computer_board(ships)
    ships.each do |ship|
      coordinates = []
      loop do
        # Select x or y direction for placement
        direction = 1 + rand(2)

        # Get allowed range for placement
        range = direction == 1 ? @boards[:computer].width : @boards[:computer].height

        # Select row/col for placement
        common_axis = direction == 1 ? 1 + rand(@boards[:computer].height) : 1 + rand(@boards[:computer].width)

        # Pick lowest coordinate for placement
        start = 1 + rand(range - ship.length)

        coordinates = generate_coordinates(start, direction, common_axis, ship.length)
        break if @boards[:computer].valid_placement?(ship, coordinates)
      end
      @boards[:computer].place(ship, coordinates)
    end
  end

  def generate_coordinates(start, direction, common_axis, length)
    coordinates = []
    for i in 0..length-1
      if direction == 1
        coordinates << (common_axis + 64).chr + (start + i).to_s
      else
        coordinates << (start + 64 + i).chr + common_axis.to_s
      end
    end
    coordinates
  end

  def place_ship(board, ship)
    coordinates = []

    puts "\nEnter the squares for the " + ship.name +  " (" + ship.length.to_s + " spaces):"
    loop do
      coordinates = gets.chomp.split("\s")
      break if board.valid_placement?(ship, coordinates)
      puts "Those are invalid coordinates. Please try again:"
    end
    board.place(ship, coordinates)
    board.render(true)
  end

  def game_over?
  end
end