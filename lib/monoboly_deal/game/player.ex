defmodule MonobolyDeal.Game.Player do
  defstruct [:name, :bank]

  def new(name) do
    %MonobolyDeal.Game.Player{name: name, bank: []}
  end
end
