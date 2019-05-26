defmodule MonobolyDeal.Deck.Property do
  alias MonobolyDeal.Deck.Property

  defstruct [:name, :color, :value, :rent_values, :image_url]

  def new(value, color, rent_values) do
    %Property{
      name: :property_card,
      value: value,
      color: color,
      rent_values: rent_values,
      image_url: get_image_url(color)
    }
  end

  defp get_image_url(color) do
    case color do
      :blue -> "/images/cards/property-blue.png"
      :brown -> "/images/cards/property-brown.png"
      :utility -> "/images/cards/property-light-green.png"
      :green -> "/images/cards/property-green.png"
      :yellow -> "/images/cards/property-yellow.png"
      :red -> "/images/cards/property-red.png"
      :orange -> "/images/cards/property-orange.png"
      :pink -> "/images/cards/property-pink.png"
      :light_blue -> "/images/cards/property-light-blue.png"
      :railroad -> "/images/cards/property-black.png"
      _ -> raise ArgumentError, "#{inspect(color)} is not a valid property dual property card."
    end
  end
end
