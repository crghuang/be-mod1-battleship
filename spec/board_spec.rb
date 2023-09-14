require 'spec_helper'

RSpec.describe Board do
  before(:each) do
    @board = Board.new
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
  end

  describe '#initialize' do
    it 'will create a new board' do
      expect(@board.cells.size).to eq(16)
      @board.cells.each_value { |v| expect(v).to be_an_instance_of(Cell) }
    end
  end

  describe '#valid_coordinate?' do
    it 'can check if coordinate is on board or not' do
      expect(@board.valid_coordinate?("A1")).to eq(true)
      expect(@board.valid_coordinate?("D1")).to eq(true)
      expect(@board.valid_coordinate?("A5")).to eq(false)
      expect(@board.valid_coordinate?("E1")).to eq(false)
      expect(@board.valid_coordinate?("A22")).to eq(false)
    end
  end

  describe '#valid_placement?' do
    it 'can reject non-adjacent placements' do
      expect(@board.valid_placement?(@cruiser, ["A1", "A2", "A4"])).to eq(false)
      expect(@board.valid_placement?(@submarine, ["A1", "C1"])).to eq(false)
      expect(@board.valid_placement?(@cruiser, ["A3", "A2", "A1"])).to eq(false)
      expect(@board.valid_placement?(@submarine, ["C1", "B1"])).to eq(false)
      expect(@board.valid_placement?(@submarine, ["D1", "B6"])).to eq(false)
      expect(@board.valid_placement?(@cruiser, ["A1", "A1", "A1"])).to eq(false)
    end
  
    it 'can invalidate diagonal ship placements' do
      expect(@board.valid_placement?(@cruiser, ["A1", "B2", "C3"])).to eq(false)
      expect(@board.valid_placement?(@submarine, ["C2", "D3"])).to eq(false)
    end

    it 'verifies valid placements' do
      expect(@board.valid_placement?(@submarine, ["A1", "A2"])).to eq(true)
      expect(@board.valid_placement?(@cruiser, ["B1", "C1", "D1"])).to eq(true)
    end
  end

  describe '#place' do
    before {
      @board.place(@cruiser, ["A1", "A2", "A3"])
      @cell_1 = @board.cells["A1"]
      @cell_2 = @board.cells["A2"]
      @cell_3 = @board.cells["A3"]
    }

    it 'creates cells for each coordinate' do
      expect(@cell_1).to be_an_instance_of(Cell)
      expect(@cell_2).to be_an_instance_of(Cell)
      expect(@cell_3).to be_an_instance_of(Cell)
    end

    it 'does not allow overlapping ships' do
      expect(@board.valid_placement?(@submarine, ["A1", "B1"])).to eq(false)
    end
  end

  describe '#render' do
    before {
      @board.place(@cruiser, ["A1", "A2", "A3"])
    }

    it 'can render the board' do
      expect(@board.render).to eq("  1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . . . . \n")
      expect(@board.render(true)).to eq("  1 2 3 4 \nA S S S . \nB . . . . \nC . . . . \nD . . . . \n")
    end

    it 'can show hits' do
      @board.fire_upon("A1")
      expect(@board.render).to eq("  1 2 3 4 \nA H . . . \nB . . . . \nC . . . . \nD . . . . \n")
    end

    it 'can show misses' do
      @board.fire_upon("D2")
      expect(@board.render).to eq("  1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . M . . \n")
    end

    it 'can show sunk ships' do
      @board.fire_upon("A1")
      @board.fire_upon("A2")
      @board.fire_upon("A3")
      expect(@board.render).to eq("  1 2 3 4 \nA X X X . \nB . . . . \nC . . . . \nD . . . . \n")
    end
  end
end