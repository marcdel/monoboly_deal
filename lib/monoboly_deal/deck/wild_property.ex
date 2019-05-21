defmodule MonobolyDeal.Deck.WildProperty do
  alias MonobolyDeal.Deck.WildProperty

  @derive {Jason.Encoder, only: [:name, :value]}
  @enforce_keys [:name, :value]
  defstruct [:name, :value]

  def new do
    %WildProperty{name: :property_wild_card, value: 0}
  end
end
