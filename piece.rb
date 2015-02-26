require 'colorize'
require 'byebug'

class Piece
  attr_accessor :position, :color, :moved
  attr_reader :board

  def initialize(board, color, position)
    @board = board
    @color = color
    @position = position
    @moved = false
  end

  def moves(position)

  end

  def possible_move?(location)

  end

  def dup(duped_board)
    self.class.new(duped_board, self.color, self.position)
  end
end
