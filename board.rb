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
    new_board.count_bombs
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
    grid.each do |row|
      row.map! {|square| square ||= Square.new(false) }
    end
  end

  def count_bombs
    grid.each_index do |row_index|
      grid.each_index do |col_index|
        pos = [row_index, col_index]
        self[pos].num_bombs = check_neighbors(pos)
      end
    end
  end

  def render
    grid.each do |row|
      row.map do |square|
        unless square.revealed
          if square.flagged
            print "f "
          else
            print "* "
          end
        else
          if square.is_bomb?
            print "b "
          elsif square.num_bombs > 0
            print square.num_bombs.to_s + " "
          else
            print "_ "
          end
        end
      end
      puts
    end
  end

  def final_render
    grid.each do |row|
      row.map do |square|
        unless square.revealed
          if square.flagged
            if square.is_bomb?
              print "x "
            else
              print "f "
            end
          elsif square.is_bomb?
              print "b "
          else
            print "* "
          end
        else
          if square.num_bombs > 0
            print square.num_bombs.to_s + " "
          else
            print "_ "
          end
        end
      end
      puts
    end
  end

  def check_neighbors(pos)
    row, col = pos
    neighbors = []
    neighbors << [row - 1, col - 1]
    neighbors << [row - 1, col]
    neighbors << [row - 1, col + 1]
    neighbors << [row + 1, col - 1]
    neighbors << [row + 1, col]
    neighbors << [row + 1, col + 1]
    neighbors << [row, col - 1]
    neighbors << [row, col + 1]
    select_neighbors = neighbors.reject { |pos| pos[0] < 0 || pos[1] < 0 ||
        pos[0] >= grid.length || pos[1] >= grid.length}

    result = 0
    select_neighbors.each do |neighbor|
      result += 1 if self[neighbor].is_bomb?
    end
    result
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
