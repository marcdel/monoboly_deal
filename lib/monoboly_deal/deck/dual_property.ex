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

  defp get_image_url(properties) do
    case properties do
      [%{color: :blue}, %{color: :green}] ->
        "/images/cards/property-blue-or-green.png"

      [%{color: :green}, %{color: :railroad}] ->
        "/images/cards/property-green-or-black.png"

      [%{color: :utility}, %{color: :railroad}] ->
        "/images/cards/property-light-green-or-black.png"

      [%{color: :light_blue}, %{color: :railroad}] ->
        "/images/cards/property-light-blue-or-black.png"

      [%{color: :light_blue}, %{color: :brown}] ->
        "/images/cards/property-light-blue-or-brown.png"

      [%{color: :pink}, %{color: :orange}] ->
        "/images/cards/property-orange-or-pink.png"

      [%{color: :red}, %{color: :yellow}] ->
        "/images/cards/property-red-or-yellow.png"

      _ ->
        raise ArgumentError, "#{inspect(properties)} is not a valid dual property card."
    end
  end
end
