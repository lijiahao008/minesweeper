class Square
  def initialize(bomb)
    @revealed = false
    @bomb = bomb
    @flagged = false
    @num_bombs = 0
  end

  attr_accessor :revealed, :flagged, :bombs_around, :num_bombs

  def is_bomb?
    @bomb
  end


end
