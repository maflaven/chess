require_relative 'sliding_piece'

class Queen < SlidingPiece
  attr_reader :type

  def initialize(board, color, position)
    @type = :queen
    super
  end

  def delta
    [
      [1, 0],   [-1, 0],
      [0, 1],   [0, -1],
      [-1, -1], [-1, 1],
      [1 , -1], [1, 1 ]
    ]
  end
end
