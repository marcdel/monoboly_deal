defmodule MonobolyDeal.Deck.DualProperty do
  alias MonobolyDeal.Deck.DualProperty

  defstruct [:name, :value, :properties, :image_url]

  def new(property1, property2) do
    %DualProperty{
      name: :dual_property_card,
      value: property1.value,
      properties: [property1, property2],
      image_url: get_image_url([property1, property2])
    }
  end

  defp get_image_url([%{color: :blue}, %{color: :green}]) do
    "/images/cards/property-blue-or-green.png"
  end

  defp get_image_url([%{color: :green}, %{color: :railroad}]) do
    "/images/cards/property-green-or-black.png"
  end

  defp get_image_url([%{color: :utility}, %{color: :railroad}]) do
    "/images/cards/property-light-green-or-black.png"
  end

  defp get_image_url([%{color: :light_blue}, %{color: :railroad}]) do
    "/images/cards/property-light-blue-or-black.png"
  end

  defp get_image_url([%{color: :light_blue}, %{color: :brown}]) do
    "/images/cards/property-light-blue-or-brown.png"
  end

  defp get_image_url([%{color: :pink}, %{color: :orange}]) do
    "/images/cards/property-orange-or-pink.png"
  end

  defp get_image_url([%{color: :red}, %{color: :yellow}]) do
    "/images/cards/property-red-or-yellow.png"
  end
end
