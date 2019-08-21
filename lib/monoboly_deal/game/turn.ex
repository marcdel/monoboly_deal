defmodule MonobolyDeal.Game.Turn do
  alias MonobolyDeal.Game.Turn

  defstruct [:player, :drawn_cards]

  def new(player) do
    %Turn{
      player: player,
      drawn_cards: []
    }
  end
end
