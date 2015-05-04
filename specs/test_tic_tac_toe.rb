require 'minitest/autorun'
require '../games/tictactoe/tic_tac_toe'

class TestTicTacToe < Minitest::Test
  def setup
    @won = false
    @game = TicTacToe.new(proc{}, proc{ @won = true })
  end

  def test_invalid_moves
    assert_raises(RuntimeError) do
      @game.play(9)
    end
    @game.play(0)
    assert_raises(RuntimeError) do
      @game.play(0)
    end
  end

  def test_win_condition
    @game.play(0) # player 1
    @game.play(4) # player 2
    @game.play(1) # player 1
    @game.play(5) # player 2
    assert_equal @won, false
    @game.play(2) # player 1
    assert_equal @won, true
  end
end