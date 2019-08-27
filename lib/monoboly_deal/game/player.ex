defmodule MonobolyDeal.Game.Player do
  defstruct [:name, :hand, :bank, :bank_total]

  def new(name) do
    %MonobolyDeal.Game.Player{name: name, hand: [], bank: [], bank_total: 0}
  end
end
