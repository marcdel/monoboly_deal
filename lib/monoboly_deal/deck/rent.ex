defmodule MonobolyDeal.Deck.Rent do
  alias MonobolyDeal.Deck.Rent

  defstruct [:name, :colors, :value, :image_url]

  def new(colors) do
    %Rent{name: :rent_card, value: 1, colors: colors, image_url: get_image_url(colors)}
  end

  defp get_image_url([:blue, :green]) do
    "/images/cards/rent-blue-or-green.png"
  end

  defp get_image_url([:red, :yellow]) do
    "/images/cards/rent-red-or-yellow.png"
  end

  defp get_image_url([:pink, :orange]) do
    "/images/cards/rent-orange-or-pink.png"
  end

  defp get_image_url([:light_blue, :brown]) do
    "/images/cards/rent-light-blue-or-brown.png"
  end

  defp get_image_url([:railroad, :utility]) do
    "/images/cards/rent-black-or-light-green.png"
  end

  defp get_image_url([
         :blue,
         :green,
         :red,
         :yellow,
         :pink,
         :orange,
         :light_blue,
         :brown,
         :railroad,
         :utility
       ]) do
    "/images/cards/rent-all-colour.png"
  end
end
