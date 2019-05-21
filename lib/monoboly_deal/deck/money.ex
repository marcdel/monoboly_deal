defmodule MonobolyDeal.Deck.Money do
  alias MonobolyDeal.Deck.Money

  @derive {Jason.Encoder, only: [:name, :value]}
  @enforce_keys [:name, :value]
  defstruct [:name, :value]

  def new(value) do
    %Money{name: :money_card, value: value}
  end
end
