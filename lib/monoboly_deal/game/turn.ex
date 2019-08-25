defmodule MonobolyDeal.Game.Turn do
  alias MonobolyDeal.Game.Turn

  defstruct [:player, :drawn_cards, :chosen_card]

  def new(player) do
    %Turn{
      player: player,
      drawn_cards: [],
      chosen_card: nil
    }
  end
end
