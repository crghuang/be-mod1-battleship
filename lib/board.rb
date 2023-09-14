
class Board
  attr_reader :cells,
              :width,
              :height

  def initialize
    @cells = generate_board
    @width = 4
    @height = 4
  end

  def valid_coordinate?(coordinate)
    return false if coordinate.chars.size != 2
    @cells.has_key?(coordinate)
  end

  def valid_placement?(ship, coordinates)
    if ship.length == coordinates.length
      coordinates_copy = coordinates.map(&:clone)

      # Validate each coordinate
      coordinates_copy.each { |coordinate| return false if !valid_coordinate?(coordinate) }

      # Check if coordinate has existing ship
      coordinates_copy.each { |coordinate| return false if !@cells[coordinate].empty? }

      # Convert from chars to ints for sequence check
      coordinates_copy.map! { |coordinate| coordinate.chars.map(&:ord) }
      coordinates_copy = coordinates_copy.transpose

      # Check whether sequential
      if coordinates_copy[0].uniq.size == 1 && coordinates_copy[1].uniq.size > 1
        return check_sequential(coordinates_copy[1])
      elsif coordinates_copy[0].uniq.size > 1 && coordinates_copy[1].uniq.size == 1
        return check_sequential(coordinates_copy[0])
      end
    end
    false
  end

  def check_sequential(coordinates)
    coordinates.each_with_index do |coordinate, i|
      return false if i > 0 && coordinate != coordinates[i-1] + 1
    end
    true
  end

  def place(ship, coordinates)
    if valid_placement?(ship, coordinates)
      coordinates.each do |coordinate|
        @cells[coordinate].place_ship(ship)
      end
    end
  end

  def render(show=false)
    display = ""
    for i in 0..@height
      if i == 0
        display << "  "
      else
        row = (i + 64).chr() # 64 offset to ASCII A
        display << row << " "
      end

      for j in 1..@width
        col = j.to_s
        if i == 0
          display << col << " "
        else
          display << @cells[row + col].render(show) << " "
        end
      end
      display << "\n"
    end
    puts "\n" + display
    display
  end

  def fire_upon(coordinate)
    @cells[coordinate].fire_upon
  end

  private

  def generate_board
    board = {}
    row = "A"
    for j in 0..3 do
      for i in 1..4 do
        label = row + i.to_s
        board.store(label, Cell.new(label))
        # board[:label] = Cell.new(label)
      end
      row = row.next
    end
    board
  end
end