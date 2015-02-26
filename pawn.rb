require_relative 'piece'
require 'byebug'


class Pawn < Piece
  attr_reader :type

  def initialize(board, color, position)
    @type = :pawn
    super
  end

  def moves
    board = @board.deep_dup

    possible_moves = []
    delta.each do |delta|
      possible_moves << check_possible_move(@position, delta, board)
    end

    kill_moves = []
    delta_kill.each do |delta|
      kill_moves << check_possible_kill(@position, delta, board)
    end

    possible_moves += kill_moves
    possible_moves.compact
  end

  def check_possible_kill(pos, delta, board)
    pos_x = pos[0] + delta[0]
    pos_y = pos[1] + delta[1]

    if board[[pos_x, pos_y]].nil?
    else board.valid_position?([pos_x, pos_y]) && board[[pos_x, pos_y]].color != self.color
      [pos_x, pos_y]
    end

  end

  def check_possible_move(pos, delta, board)
    pos_x = pos[0] + delta[0]
    pos_y = pos[1] + delta[1]

    if board.valid_position?([pos_x, pos_y])
      if board[[pos_x, pos_y]].nil? || board[[pos_x, pos_y]].color != self.color
        [pos_x, pos_y]
      end
    end

  end

  def delta
    if @moved
      self.color == :white ? [-1, 0] : [1, 0]
    else
      self.moved = true
      self.color == :white ? [[-2, 0], [-1, 0]] : [[2, 0], [1, 0]]
    end
  end

  def delta_kill
    self.color == :white ? [[-1, 1], [-1, -1]] : [[1, -1], [1, 1]]
  end
end
