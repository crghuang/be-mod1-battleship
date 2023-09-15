
class Game
  attr_reader :boards
              :ships
              :winner

  def initialize()
    @boards = {}
    @ships = {}
    @winner
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

    @ships[:player] = [
      Ship.new("Cruiser", 3),
      Ship.new("Submarine", 2)
    ]

    @ships[:computer] = [
      Ship.new("Cruiser", 3),
      Ship.new("Submarine", 2)
    ]

    set_up_computer_board(@ships[:computer])

    puts "\nI have laid out my ships on the grid.\n" +
    "You now need to lay out your two ships.\n" + 
    "The Cruiser is three units long and the Submarine is two units long."
    @boards[:player].render

    @ships[:player].each { |ship| place_ship(@boards[:player], ship) }
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

  def play_game
    loop do
      turn
      break if game_over?
    end
    display_winner
    start_game
  end

  def render_boards
    puts "\n=============COMPUTER BOARD============="
    @boards[:computer].render
    puts "\n==============PLAYER BOARD=============="
    @boards[:player].render(true)
  end

  def turn
    render_boards
    player_turn
    computer_turn
  end

  def player_turn
    puts "\nEnter the coordinate for your shot:"
    coordinate = ""
    loop do
      coordinate = gets.chomp
      break if @boards[:computer].valid_coordinate?(coordinate)
      puts "Please enter a valid coordinate:"
    end
    @boards[:computer].cells[coordinate].fire_upon
    report_shot_result(:computer, coordinate)
  end

  def computer_turn
    coordinate = ""
    loop do
      index = rand(@boards[:player].height * @boards[:player].width)
      coordinate = (index/4.floor + 1 + 64).chr + (index % 4).to_s
      break if !@boards[:player].cells[coordinate].fired_upon?
    end
    @boards[:player].cells[coordinate].fire_upon
    report_shot_result(:player, coordinate)
  end

  def report_shot_result(player, coordinate)
    who = player == :player ? "My" : "Your"
    case @boards[player].cells[coordinate].render
    when "X"
      puts who + " shot on " + coordinate + " sunk a ship."
    when "H"
      puts who + " shot on " + coordinate + " was a hit."
    when "M"
      puts who + " shot on " + coordinate + " was a miss."
    else
      puts "Error! Invalid player turn result!"
    end
  end

  def game_over?
    @ships.each_value do |ary|
      return true if overall_health(ary) == 0
    end
    false
  end

  def overall_health(ships)
    health = 0
    ships.each { |ship| health += ship.health }
    health
  end

  def display_winner
    @ships.each do |player, ary|
      if overall_health(ary) > 0
        who = player == :player ? "You" : "I"
        puts who + " won!"
        return
      end
    end
  end
end