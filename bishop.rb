require_relative 'sliding_piece'

class Bishop < SlidingPiece
  attr_reader :type

  def initialize(board, color, position)
    @type = :bishop
    super
  end

  def delta
    [
      [-1, -1], [-1, 1],
      [1 , -1], [1, 1 ]
    ]
  end
end
