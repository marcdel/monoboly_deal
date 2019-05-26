defmodule MonobolyDeal.Deck.Action do
  alias MonobolyDeal.Deck.Action

  defstruct [:name, :type, :value, :image_url]

  def new(value, type) do
    %Action{name: :action_card, value: value, type: type, image_url: get_image_url(type)}
  end

  defp get_image_url(:deal_breaker), do: "/images/cards/deal-breaker.png"
  defp get_image_url(:just_say_no), do: "/images/cards/say-no.png"
  defp get_image_url(:pass_go), do: "/images/cards/pass-go.png"
  defp get_image_url(:forced_deal), do: "/images/cards/forced-deal.png"
  defp get_image_url(:sly_deal), do: "/images/cards/sly-deal.png"
  defp get_image_url(:debt_collector), do: "/images/cards/debt-collector.png"
  defp get_image_url(:its_my_birthday), do: "/images/cards/birthday.png"
  defp get_image_url(:double_the_rent), do: "/images/cards/double-rent.png"
  defp get_image_url(:house), do: "/images/cards/house.png"
  defp get_image_url(:hotel), do: "/images/cards/hotel.png"
end
