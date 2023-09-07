require 'spec_helper'

RSpec.describe Cell do
  before(:each) do
    @cell = Cell.new("B4")
    @cruiser = Ship.new("Cruiser", 3)
  end

  describe '#initialize' do
    it 'can initialize' do
      expect(@cell).to be_an_instance_of(Cell)
      expect(@cell.coordinate).to eq("B4")
      expect(@cell.ship).to eq(nil)
    end
  end

  describe '#place_ship' do
    it 'can place a ship in the cell' do
      @cell.place_ship(@cruiser)
      expect(@cell.ship).to be_an_instance_of(Ship)
    end
  end

  describe '#empty?' do
    it 'can check if it is empty' do
      expect(@cell.empty?).to eq(true)
      @cell.place_ship(@cruiser)
      expect(@cell.empty?).to eq(false)
    end
  end

  describe '#fire_upon' do
    it 'can fire on and store whether ship fired upon' do
      @cell.place_ship(@cruiser)
      expect(@cell.fired_upon?).to eq(false)
      @cell.fire_upon
      expect(@cell.ship.health).to eq(2)
      expect(@cell.fired_upon?).to eq(true)
    end
  end

  describe '#render' do
    before {
      @cell_2 = Cell.new("C3")
    }

    it 'can show a cell not fired upon' do
      expect(@cell.render).to eq(".")
      expect(@cell_2.render).to eq(".")
    end

    it 'can show a miss' do
      @cell_2.fire_upon
      expect(@cell_2.render).to eq("M")
      @cell_2.place_ship(@cruiser)
    end

    it 'can show a ship placement' do
      @cell_2.place_ship(@cruiser)
      expect(@cell_2.render(true)).to eq("S")
    end

    it 'can show a hit' do
      @cell_2.place_ship(@cruiser)
      @cell_2.fire_upon
      expect(@cell_2.render).to eq("H")
    end

    it 'can show a sunk ship' do
      @cell_2.place_ship(@cruiser)
      @cell_2.fire_upon
      expect(@cruiser.sunk?).to eq(false)
      @cruiser.hit
      @cruiser.hit
      expect(@cruiser.sunk?).to eq(true)
      expect(@cell_2.render).to eq("X")
    end
  end
end