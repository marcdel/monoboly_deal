defmodule MonobolyDeal.Game.Player do
  defstruct [:name, :bank, :bank_total]

  def new(name) do
    %MonobolyDeal.Game.Player{name: name, bank: [], bank_total: 0}
  end
end
