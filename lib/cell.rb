
class Cell
  attr_reader :coordinate
  attr_accessor :ship

  def initialize(coordinate)
    @coordinate = coordinate
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
    if @ship == nil
      @ship = ship
    end
  end

  def fired_upon?
    if @ship != nil && @ship.health < @ship.length
      true
    else
      false
    end
  end

  def fire_upon
    if @ship != nil
      @ship.hit
    end
  end
end