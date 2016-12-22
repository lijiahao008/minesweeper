require_relative "board"
require "byebug"

class MinesweeperGame

  def initialize(board)
    @board = board
  end

  def prompt_pos
    puts "Enter a coordinate: "
    input = gets.chomp.split(",")
    until input.length == 2
      puts "Enter a coordinate: "
      input = gets.chomp.split(",")
    end
    input.map { |char| Integer(char) }
  end

  def prompt_option
    puts "Enter r to reveal, enter f to flag: "
    gets.chomp.downcase
  end

  def play
    until game_over?
      render
      play_turn
    end
    board.final_render
    puts "Game over"
    puts board.won? ? "You won" : "You lost"
  end

  def game_over?
    board.won? || board.lost?
  end

  def play_turn
    op = prompt_option until op == "r" || op == "f"
    pos = prompt_pos until pos.is_a?(Array)
    op == "r" ? board.reveal(pos) : board.flag(pos)
  end

  def render
    board.render
  end

  private

  attr_reader :board


end


game = MinesweeperGame.new(Board.new(9))
game.play
