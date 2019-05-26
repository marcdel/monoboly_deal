defmodule MonobolyDeal.Deck.Action do
  alias MonobolyDeal.Deck.Action

  defstruct [:name, :type, :value, :image_url]

  def new(value, type) do
    %Action{name: :action_card, value: value, type: type, image_url: get_image_url(type)}
  end

  defp get_image_url(type) do
    case type do
      :deal_breaker -> "/images/cards/deal-breaker.png"
      :just_say_no -> "/images/cards/say-no.png"
      :pass_go -> "/images/cards/pass-go.png"
      :forced_deal -> "/images/cards/forced-deal.png"
      :sly_deal -> "/images/cards/sly-deal.png"
      :debt_collector -> "/images/cards/debt-collector.png"
      :its_my_birthday -> "/images/cards/birthday.png"
      :double_the_rent -> "/images/cards/double-rent.png"
      :house -> "/images/cards/house.png"
      :hotel -> "/images/cards/hotel.png"
      _ -> raise ArgumentError, "The type '#{type}' is not a valid action card type."
    end
  end
end
