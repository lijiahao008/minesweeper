class Square
  def initialize(bomb)
    @revealed = false
    @bomb = bomb
    @flagged = false
  end

  attr_accessor :revealed, :flagged, :bombs_around

  def is_bomb?
    @bomb
  end


end
