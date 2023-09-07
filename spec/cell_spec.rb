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

  describe '#fired_upon?' do
    it 'can check if the ship in cell has been fired upon' do

    end
  end
end