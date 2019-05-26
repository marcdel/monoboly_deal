defmodule MonobolyDeal.Deck.Money do
  alias MonobolyDeal.Deck.Money

  defstruct [:name, :value, :image_url]

  def new(value) do
    %Money{name: :money_card, value: value, image_url: get_image_url(value)}
  end

  defp get_image_url(value) do
    case value do
      1 -> "/images/cards/money-1m.png"
      2 -> "/images/cards/money-2m.png"
      3 -> "/images/cards/money-3m.png"
      4 -> "/images/cards/money-4m.png"
      5 -> "/images/cards/money-5m.png"
      10 -> "/images/cards/money-10m.png"
      _ -> raise ArgumentError, "#{value} is not a valid money amount."
    end
  end
end
