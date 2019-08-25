defmodule MonobolyDeal.Deck.WildProperty do
  alias MonobolyDeal.Deck.{Card, WildProperty}

  defstruct [:id, :name, :value, :image_url]

  def new do
    %WildProperty{
      id: Card.generate_id(),
      name: :property_wild_card,
      value: 0,
      image_url: "/images/cards/property-wildcard.png"
    }
  end
end
