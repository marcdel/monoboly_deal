defmodule MonobolyDeal.Deck do
  alias MonobolyDeal.Deck.{
    Money,
    Action,
    Rent,
    Property,
    DualProperty,
    WildProperty
  }

  def new do
    []
    |> add_money_cards()
    |> add_action_cards()
    |> add_rent_cards()
    |> add_property_cards()
    |> add_dual_property_cards()
    |> add_wild_property_cards()
  end

  def shuffle(cards) do
    Enum.shuffle(cards)
  end

  defp add_money_cards(cards) do
    cards
    |> Kernel.++(for _ <- 1..6, do: Money.new(1))
    |> Kernel.++(for _ <- 1..5, do: Money.new(2))
    |> Kernel.++(for _ <- 1..3, do: Money.new(3))
    |> Kernel.++(for _ <- 1..3, do: Money.new(4))
    |> Kernel.++(for _ <- 1..2, do: Money.new(5))
    |> Kernel.++([Money.new(10)])
  end

  # credo:disable-for-next-line Credo.Check.Refactor.CyclomaticComplexity
  defp add_action_cards(cards) do
    cards
    |> Kernel.++(for _ <- 1..2, do: Action.new(:deal_breaker))
    |> Kernel.++(for _ <- 1..3, do: Action.new(:just_say_no))
    |> Kernel.++(for _ <- 1..10, do: Action.new(:pass_go))
    |> Kernel.++(for _ <- 1..3, do: Action.new(:forced_deal))
    |> Kernel.++(for _ <- 1..3, do: Action.new(:sly_deal))
    |> Kernel.++(for _ <- 1..3, do: Action.new(:debt_collector))
    |> Kernel.++(for _ <- 1..3, do: Action.new(:its_my_birthday))
    |> Kernel.++(for _ <- 1..2, do: Action.new(:double_the_rent))
    |> Kernel.++(for _ <- 1..3, do: Action.new(:house))
    |> Kernel.++(for _ <- 1..2, do: Action.new(:hotel))
  end

  defp add_rent_cards(cards) do
    cards
    |> Kernel.++(for _ <- 1..2, do: Rent.new([:blue, :green]))
    |> Kernel.++(for _ <- 1..2, do: Rent.new([:red, :yellow]))
    |> Kernel.++(for _ <- 1..2, do: Rent.new([:pink, :orange]))
    |> Kernel.++(for _ <- 1..2, do: Rent.new([:light_blue, :brown]))
    |> Kernel.++(for _ <- 1..2, do: Rent.new([:railroad, :utility]))
    |> Kernel.++(for _ <- 1..3, do: Rent.new(:wild_rent_card))
  end

  # credo:disable-for-next-line Credo.Check.Refactor.CyclomaticComplexity
  defp add_property_cards(cards) do
    cards
    |> Kernel.++(for _ <- 1..2, do: Property.new(:blue))
    |> Kernel.++(for _ <- 1..2, do: Property.new(:brown))
    |> Kernel.++(for _ <- 1..2, do: Property.new(:utility))
    |> Kernel.++(for _ <- 1..3, do: Property.new(:green))
    |> Kernel.++(for _ <- 1..3, do: Property.new(:yellow))
    |> Kernel.++(for _ <- 1..3, do: Property.new(:red))
    |> Kernel.++(for _ <- 1..3, do: Property.new(:orange))
    |> Kernel.++(for _ <- 1..3, do: Property.new(:pink))
    |> Kernel.++(for _ <- 1..3, do: Property.new(:light_blue))
    |> Kernel.++(for _ <- 1..4, do: Property.new(:railroad))
  end

  defp add_dual_property_cards(cards) do
    cards
    |> Kernel.++([
      DualProperty.new(
        Property.new(:blue),
        Property.new(:green)
      )
    ])
    |> Kernel.++([
      DualProperty.new(
        Property.new(:green),
        Property.new(:railroad)
      )
    ])
    |> Kernel.++([
      DualProperty.new(
        Property.new(:utility),
        Property.new(:railroad)
      )
    ])
    |> Kernel.++([
      DualProperty.new(
        Property.new(:light_blue),
        Property.new(:railroad)
      )
    ])
    |> Kernel.++([
      DualProperty.new(
        Property.new(:light_blue),
        Property.new(:brown)
      )
    ])
    |> Kernel.++(
      for _ <- 1..2,
          do:
            DualProperty.new(
              Property.new(:pink),
              Property.new(:orange)
            )
    )
    |> Kernel.++(
      for _ <- 1..2,
          do:
            DualProperty.new(
              Property.new(:red),
              Property.new(:yellow)
            )
    )
  end

  defp add_wild_property_cards(cards) do
    cards
    |> Kernel.++(for _ <- 1..2, do: WildProperty.new())
  end
end
