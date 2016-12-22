require_relative "square"
require "byebug"

class Board

  def initialize(size)
    @grid = new_grid(size)
    @num_bombs = size / 3
    populate
    count_bombs

  end

  def new_grid(size)
    grid = Array.new(size) { Array.new (size)}
  end


  def populate
    @bombs_pos = []
    @num_bombs.times do |bomb|
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
        if square.revealed
          if square.num_bombs > 0
            print square.num_bombs.to_s + " "
          elsif square.is_bomb?
            print "b "
          else
            print "_ "
          end
        else
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
        end
      end
      #   unless square.revealed
      #     if square.flagged
      #       if square.is_bomb?
      #         print "x "
      #       else
      #         print "f "
      #       end
      #     elsif square.is_bomb?
      #         print "b "
      #     else
      #       print "* "
      #     end
      #   else
      #     if square.num_bombs > 0
      #       print square.num_bombs.to_s + " "
      #     else
      #       print "_ "
      #     end
      #   end
      # end
      puts
    end
  end

  def neighbors(pos)
    row, col = pos
    neighbors_pos = []
    neighbors_pos << [row - 1, col - 1]
    neighbors_pos << [row - 1, col]
    neighbors_pos << [row - 1, col + 1]
    neighbors_pos << [row + 1, col - 1]
    neighbors_pos << [row + 1, col]
    neighbors_pos << [row + 1, col + 1]
    neighbors_pos << [row, col - 1]
    neighbors_pos << [row, col + 1]


    select_neighbors = neighbors_pos.reject { |pos| pos[0] < 0 || pos[1] < 0 ||
        pos[0] >= grid.length || pos[1] >= grid.length}
    select_neighbors
  end

  def check_neighbors(pos)
    result = 0
    return result if self[pos].is_bomb?
    neighbors(pos).each do |neighbor|
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
    return if self[pos].revealed
    self[pos].revealed = true unless self[pos].flagged
    return if self[pos].num_bombs > 0 || self[pos].is_bomb?

    neighbors(pos).each do |neighbor_pos|
      reveal(neighbor_pos)
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
  attr_reader :grid, :num_bombs
end
