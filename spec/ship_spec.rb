require 'spec_helper'

RSpec.describe Ship do
  before(:each) do
    @cruiser = Ship.new("Cruiser", 3)
  end

  describe '#initialize' do
    it 'can initialize' do
      expect(@cruiser).to be_an_instance_of(Ship)
      expect(@cruiser.name).to eq("Cruiser")
      expect(@cruiser.length).to eq(3)
    end
  end

  describe '#sunk?' do
    it 'can check whether the ship has sunk' do
      expect(@cruiser.sunk?).to eq(false)
      @cruiser.hit
      expect(@cruiser.sunk?).to eq(false)
      @cruiser.hit
      @cruiser.hit
      expect(@cruiser.sunk?).to eq(true)
    end
  end

  describe '#hit' do
    it 'can track hits' do
      @cruiser.hit
      expect(@cruiser.health).to eq(2)
      @cruiser.hit
      expect(@cruiser.health).to eq(1)
    end
  end
end