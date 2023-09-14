
class Cell
  attr_reader :coordinate,
              :fired_upon

  attr_accessor :ship

  alias :fired_upon? :fired_upon

  def initialize(coordinate)
    @coordinate = coordinate
    @fired_upon = false
    @ship
  end

  def empty?
    if @ship == nil
      true
    else
      false
    end
  end

  def place_ship(ship)
    if empty? # @ship == nil
      @ship = ship
    end
  end

  def fire_upon
    @fired_upon = true
    if @ship != nil
      @ship.hit
    end
  end

  def render(show=false)
    if !@fired_upon
      if show && @ship != nil
        "S"
      else
        "."
      end
    else
      if @ship == nil
        "M"
      else
        if @ship.health > 0
          "H"
        else
          "X"
        end
      end
    end
  end
end