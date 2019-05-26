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

  defp get_image_url(:blue), do: "/images/cards/property-blue.png"
  defp get_image_url(:brown), do: "/images/cards/property-brown.png"
  defp get_image_url(:utility), do: "/images/cards/property-light-green.png"
  defp get_image_url(:green), do: "/images/cards/property-green.png"
  defp get_image_url(:yellow), do: "/images/cards/property-yellow.png"
  defp get_image_url(:red), do: "/images/cards/property-red.png"
  defp get_image_url(:orange), do: "/images/cards/property-orange.png"
  defp get_image_url(:pink), do: "/images/cards/property-pink.png"
  defp get_image_url(:light_blue), do: "/images/cards/property-light-blue.png"
  defp get_image_url(:railroad), do: "/images/cards/property-black.png"
end
