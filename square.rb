class Square
  def initialize(bomb)
    @revealed = false
    @bomb = bomb
    @flagged = false
  end

  attr_accessor :revealed, :flagged

  def is_bomb?
    @bomb
  end


end
