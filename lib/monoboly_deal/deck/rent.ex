defmodule MonobolyDeal.Deck.Rent do
  alias MonobolyDeal.Deck.Rent

  @derive {Jason.Encoder, only: [:name, :value, :colors]}
  @enforce_keys [:name, :colors, :value]
  defstruct [:name, :colors, :value]

  def new(colors) do
    %Rent{name: :rent_card, value: 1, colors: colors}
  end
end
