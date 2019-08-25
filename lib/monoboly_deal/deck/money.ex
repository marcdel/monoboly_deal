defmodule MonobolyDeal.Deck.Money do
  alias MonobolyDeal.Deck.{Card, Money}

  defstruct [:id, :name, :value, :image_url]

  def new(value) do
    %Money{
      id: Card.generate_id(),
      name: :money_card,
      value: value,
      image_url: get_image_url(value)
    }
  end

  defp get_image_url(1), do: "/images/cards/money-1m.png"
  defp get_image_url(2), do: "/images/cards/money-2m.png"
  defp get_image_url(3), do: "/images/cards/money-3m.png"
  defp get_image_url(4), do: "/images/cards/money-4m.png"
  defp get_image_url(5), do: "/images/cards/money-5m.png"
  defp get_image_url(10), do: "/images/cards/money-10m.png"
end
