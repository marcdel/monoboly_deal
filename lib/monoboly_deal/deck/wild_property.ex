defmodule MonobolyDeal.Deck.WildProperty do
  alias MonobolyDeal.Deck.WildProperty

  defstruct [:name, :value, :image_url]

  def new do
    %WildProperty{
      name: :property_wild_card,
      value: 0,
      image_url: "/images/cards/property-wildcard.png"
    }
  end
end
