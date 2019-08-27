defmodule MonobolyDeal.Game.Player do
  defstruct [:name, :hand, :bank, :bank_total]

  def new(name) do
    %MonobolyDeal.Game.Player{name: name, hand: [], bank: [], bank_total: 0}
  end

  def add_to_hand(player, cards) do
    %{player | hand: player.hand ++ cards}
  end

  def add_to_bank(%{bank: nil} = player, card) do
    %{
      player
      | bank: [card],
        bank_total: card.value,
        hand: Enum.reject(player.hand, fn c -> c.id == card.id end)
    }
  end

  def add_to_bank(player, card) do
    %{
      player
      | bank: player.bank ++ [card],
        bank_total: player.bank_total + card.value,
        hand: Enum.reject(player.hand, fn c -> c.id == card.id end)
    }
  end
end
