require_relative "square"

class Board
  SIZE = 5
  BOMBS = SIZE * SIZE / 3
  def initialize(grid = Board.blank_grid )
    @grid = grid
  end

  def self.default_grid
    new_board = self.new
    new_board.populate
    new_board
  end

  def self.blank_grid
    Array.new(SIZE) { Array.new (SIZE)}
  end

  def populate
    num_bombs = BOMBS
    @bombs_pos = []
    num_bombs.times do |bomb|
      pos = [rand(grid.length), rand(grid.length)]
      while @bombs_pos.include?(pos)
        pos = [rand(grid.length), rand(grid.length)]
      end
      self[pos] = Square.new(true)
      @bombs_pos << pos
    end
  end

  def render
    grid.each { |row| puts row.join(" ")}
  end

  def won?
    grid.flatten.reject {|square| square.is_bomb?}.all? { |square| square.revealed }
  end

  def lost?
    @bombs_pos.count {|pos| self[pos].revealed} > 0
  end

  def flag(pos)
    self[pos].flagged = !self[pos].flagged
  end

  def reveal(pos)

    unless self[pos].revealed || self[pos].flagged
      self[pos].revealed = true
    else
      puts "Invalid input"
    end
  end

  def [](pos)
    row, col = pos
    grid[row][col]
  end

  def []=(pos, val)
    row, col = pos
    grid[row][col] = val
  end

  private
  attr_reader :grid
end

b = Board.default_grid
p b
