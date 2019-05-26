defmodule MonobolyDeal.Deck.Rent do
  alias MonobolyDeal.Deck.Rent

  defstruct [:name, :colors, :value, :image_url]

  def new(colors) do
    %Rent{name: :rent_card, value: 1, colors: colors, image_url: get_image_url(colors)}
  end

  defp get_image_url(colors) do
    case colors do
      [:blue, :green] ->
        "/images/cards/rent-blue-or-green.png"

      [:red, :yellow] ->
        "/images/cards/rent-red-or-yellow.png"

      [:pink, :orange] ->
        "/images/cards/rent-orange-or-pink.png"

      [:light_blue, :brown] ->
        "/images/cards/rent-light-blue-or-brown.png"

      [:railroad, :utility] ->
        "/images/cards/rent-black-or-light-green.png"

      [:blue, :green, :red, :yellow, :pink, :orange, :light_blue, :brown, :railroad, :utility] ->
        "/images/cards/rent-all-colour.png"

      _ ->
        raise ArgumentError, "#{inspect(colors)} is not a valid property rent card."
    end
  end
end
