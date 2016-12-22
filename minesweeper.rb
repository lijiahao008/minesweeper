require_relative "board"
require "byebug"

class MinesweeperGame

  def initialize(board)
    @board = board
  end

  def prompt_pos
    puts "Enter a coordinate: "
    gets.chomp.split(",").map { |char| Integer(char) }
  end

  def prompt_option
    puts "Enter r to reveal, enter f to flag: "
    gets.chomp.downcase
  end

  def play
     p board
    until game_over?
      render
      play_turn
    end
    puts "Game over"
    puts board.won? ? "You won" : "You lost"
  end

  def game_over?
    board.won? || board.lost?
  end

  def play_turn
    op = prompt_option
    pos = prompt_pos
    op == "r" ? board.reveal(pos) : board.flag(pos)
  end

  def render
    board.render
  end

  private

  attr_reader :board


end


game = MinesweeperGame.new(Board.default_grid)
game.play
