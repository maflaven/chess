require 'byebug'
require_relative 'piece'

class SlidingPiece < Piece

  def moves
    board = @board.deep_dup

    possible_moves = []

    delta.each do |delta|
      possible_moves += check_possible_move(@position, delta, board)
    end

    possible_moves.compact.uniq
  end

  def check_possible_move(pos, delta, board)
    pos_x = pos[0] + delta[0]
    pos_y = pos[1] + delta[1]

    increments = []
    increments << check_space(pos_x, pos_y, board, delta)
    until !(board.valid_position?([pos_x, pos_y])) || board.occupied?([pos_x, pos_y])
      pos_x = pos_x + delta[0]
      pos_y = pos_y + delta[1]
      increments << check_space(pos_x, pos_y, board, delta)
    end

    increments
  end

  def check_space(pos_x, pos_y, board, delta)
    # debugger
    if board.valid_position?([pos_x, pos_y])
      if board[[pos_x, pos_y]].nil? || board[[pos_x, pos_y]].color != self.color
        return [pos_x, pos_y]
      else
        pos_x = pos_x - delta[0]
        pos_y = pos_y - delta[1]
        return [pos_x, pos_y]
      end
    end
    []
  end

  def delta

  end
end
