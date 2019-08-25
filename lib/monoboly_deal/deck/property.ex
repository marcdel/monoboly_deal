defmodule MonobolyDeal.Deck.Property do
  alias MonobolyDeal.Deck.{Card, Property}

  defstruct [:id, :name, :color, :value, :rent_values, :image_url]

  def new(color) do
    case color do
      :blue ->
        %Property{
          id: Card.generate_id(),
          value: 4,
          color: color,
          rent_values: [3, 8],
          image_url: "/images/cards/property-blue.png"
        }

      :brown ->
        %Property{
          id: Card.generate_id(),
          value: 1,
          color: color,
          rent_values: [1, 2],
          image_url: "/images/cards/property-brown.png"
        }

      :utility ->
        %Property{
          id: Card.generate_id(),
          value: 2,
          color: color,
          rent_values: [1, 2],
          image_url: "/images/cards/property-light-green.png"
        }

      :green ->
        %Property{
          id: Card.generate_id(),
          value: 4,
          color: color,
          rent_values: [2, 4, 7],
          image_url: "/images/cards/property-green.png"
        }

      :yellow ->
        %Property{
          id: Card.generate_id(),
          value: 3,
          color: color,
          rent_values: [2, 4, 6],
          image_url: "/images/cards/property-yellow.png"
        }

      :red ->
        %Property{
          id: Card.generate_id(),
          value: 3,
          color: color,
          rent_values: [2, 3, 6],
          image_url: "/images/cards/property-red.png"
        }

      :orange ->
        %Property{
          id: Card.generate_id(),
          value: 2,
          color: color,
          rent_values: [1, 3, 5],
          image_url: "/images/cards/property-orange.png"
        }

      :pink ->
        %Property{
          id: Card.generate_id(),
          value: 2,
          color: color,
          rent_values: [1, 2, 4],
          image_url: "/images/cards/property-pink.png"
        }

      :light_blue ->
        %Property{
          id: Card.generate_id(),
          value: 1,
          color: color,
          rent_values: [1, 2, 3],
          image_url: "/images/cards/property-light-blue.png"
        }

      :railroad ->
        %Property{
          id: Card.generate_id(),
          value: 2,
          color: color,
          rent_values: [1, 2, 3, 4],
          image_url: "/images/cards/property-black.png"
        }
    end
  end
end
