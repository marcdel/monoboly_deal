defmodule MonobolyDeal.Deck.Action do
  alias MonobolyDeal.Deck.{Action, Card}

  defstruct [:id, :name, :type, :value, :image_url]

  def new(type) do
    case type do
      :deal_breaker ->
        %Action{
          id: Card.generate_id(),
          name: :action_card,
          value: 5,
          type: type,
          image_url: "/images/cards/deal-breaker.png"
        }

      :just_say_no ->
        %Action{
          id: Card.generate_id(),
          name: :action_card,
          value: 4,
          type: type,
          image_url: "/images/cards/say-no.png"
        }

      :pass_go ->
        %Action{
          id: Card.generate_id(),
          name: :action_card,
          value: 1,
          type: type,
          image_url: "/images/cards/pass-go.png"
        }

      :forced_deal ->
        %Action{
          id: Card.generate_id(),
          name: :action_card,
          value: 3,
          type: type,
          image_url: "/images/cards/forced-deal.png"
        }

      :sly_deal ->
        %Action{
          id: Card.generate_id(),
          name: :action_card,
          value: 3,
          type: type,
          image_url: "/images/cards/sly-deal.png"
        }

      :debt_collector ->
        %Action{
          id: Card.generate_id(),
          name: :action_card,
          value: 3,
          type: type,
          image_url: "/images/cards/debt-collector.png"
        }

      :its_my_birthday ->
        %Action{
          id: Card.generate_id(),
          name: :action_card,
          value: 2,
          type: type,
          image_url: "/images/cards/birthday.png"
        }

      :double_the_rent ->
        %Action{
          id: Card.generate_id(),
          name: :action_card,
          value: 1,
          type: type,
          image_url: "/images/cards/double-rent.png"
        }

      :house ->
        %Action{
          id: Card.generate_id(),
          name: :action_card,
          value: 3,
          type: type,
          image_url: "/images/cards/house.png"
        }

      :hotel ->
        %Action{
          id: Card.generate_id(),
          name: :action_card,
          value: 4,
          type: type,
          image_url: "/images/cards/hotel.png"
        }
    end
  end
end
