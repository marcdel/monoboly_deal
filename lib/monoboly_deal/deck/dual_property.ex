defmodule MonobolyDeal.Deck.DualProperty do
  alias MonobolyDeal.Deck.DualProperty

  @derive {Jason.Encoder, only: [:name, :value, :properties]}
  @enforce_keys [:name, :value, :properties]
  defstruct [:name, :value, :properties]

  def new(property1, property2) do
    %DualProperty{
      name: :dual_property_card,
      value: property1.value,
      properties: [property1, property2]
    }
  end
end
