class TicTacToe
  attr_accessor :field
  attr_accessor :current_player
  attr_accessor :cb_turn
  attr_accessor :cb_win

  def initialize
    reset!
  end

  # initialize game states
  def reset!
    @current_player = 1
    # define our map
    @field = [0] * 9
    @moves = { 1=> [0]* 9, 2=> [0]* 9 }
    # define end game conditions
    @endgames = [
        [1,1,1,0,0,0,0,0,0],
        [0,0,0,1,1,1,0,0,0],
        [0,0,0,0,0,0,1,1,1],
        [1,0,0,1,0,0,1,0,0],
        [0,1,0,0,1,0,0,1,0],
        [0,0,1,0,0,1,0,0,1],
        [1,0,0,0,1,0,0,0,1],
        [0,0,1,0,1,0,1,0,0]
    ]
  end

  def valid_move?(player, index)
    return 'Not your turn' if player != @current_player
    # cannot place outside field bounds
    return 'Index out of bounds' if index < 0 || index > 8
    # cannot place into the same place twice
    'Place full' unless @field[index] == 0
  end

  def check_win_condition(endgame)
    # check if current player reached an endgame scenario
    @moves[@current_player].zip(endgame).reduce(0) do |r, z|
      r+= z[0] & z[1]
    end > 2
  end

  def end_game?
    # check if endgame has been reached by any player
    @endgames.any? { |e| check_win_condition(e)  }
  end

  def play(player, index)
    error = valid_move? player, index
    # throw error if the move is invalid
    raise error unless error.nil?
    # mark field of choice
    @field[index] = @current_player
    # record current player's move
    @moves[@current_player][index] = 1
    # check end game condition, if reached, declare winner
    if end_game?
      @cb_win.call @current_player if @cb_win
      return
    end
    # next turn
    @current_player += 1
    @current_player = 1 if @current_player > 2

    @cb_turn.call @current_player if @cb_turn
  end
end
