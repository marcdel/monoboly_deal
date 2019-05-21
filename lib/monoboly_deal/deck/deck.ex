defmodule MonobolyDeal.Deck do
  alias MonobolyDeal.Deck.{
    Money,
    Action,
    Rent,
    Property,
    DualProperty,
    WildProperty
  }

  def shuffle do
    Enum.shuffle(cards())
  end

  def cards do
    []
    |> add_money_cards()
    |> add_action_cards()
    |> add_rent_cards()
    |> add_property_cards()
    |> add_dual_property_cards()
    |> Kernel.++(for _ <- 1..2, do: WildProperty.new())
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
    |> Kernel.++(for _ <- 1..2, do: Action.new(5, :deal_breaker))
    |> Kernel.++(for _ <- 1..3, do: Action.new(4, :just_say_no))
    |> Kernel.++(for _ <- 1..10, do: Action.new(1, :pass_go))
    |> Kernel.++(for _ <- 1..3, do: Action.new(3, :forced_deal))
    |> Kernel.++(for _ <- 1..3, do: Action.new(3, :sly_deal))
    |> Kernel.++(for _ <- 1..3, do: Action.new(3, :debt_collector))
    |> Kernel.++(for _ <- 1..3, do: Action.new(2, :its_my_birthday))
    |> Kernel.++(for _ <- 1..2, do: Action.new(1, :double_the_rent))
    |> Kernel.++(for _ <- 1..3, do: Action.new(3, :house))
    |> Kernel.++(for _ <- 1..2, do: Action.new(4, :hotel))
  end

  defp add_rent_cards(cards) do
    cards
    |> Kernel.++(for _ <- 1..2, do: Rent.new([:blue, :green]))
    |> Kernel.++(for _ <- 1..2, do: Rent.new([:red, :yellow]))
    |> Kernel.++(for _ <- 1..2, do: Rent.new([:pink, :orange]))
    |> Kernel.++(for _ <- 1..2, do: Rent.new([:light_blue, :brown]))
    |> Kernel.++(for _ <- 1..2, do: Rent.new([:railroad, :utility]))
    |> Kernel.++(
      for _ <- 1..3,
          do:
            Rent.new([
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
            ])
    )
  end

  # credo:disable-for-next-line Credo.Check.Refactor.CyclomaticComplexity
  defp add_property_cards(cards) do
    cards
    |> Kernel.++(for _ <- 1..2, do: Property.new(4, :blue, [3, 8]))
    |> Kernel.++(for _ <- 1..2, do: Property.new(1, :brown, [1, 2]))
    |> Kernel.++(for _ <- 1..2, do: Property.new(2, :utility, [1, 2]))
    |> Kernel.++(for _ <- 1..3, do: Property.new(4, :green, [2, 4, 7]))
    |> Kernel.++(for _ <- 1..3, do: Property.new(3, :yellow, [2, 4, 6]))
    |> Kernel.++(for _ <- 1..3, do: Property.new(3, :red, [2, 3, 6]))
    |> Kernel.++(for _ <- 1..3, do: Property.new(2, :orange, [1, 3, 5]))
    |> Kernel.++(for _ <- 1..3, do: Property.new(2, :pink, [1, 2, 4]))
    |> Kernel.++(for _ <- 1..3, do: Property.new(1, :light_blue, [1, 2, 3]))
    |> Kernel.++(for _ <- 1..4, do: Property.new(2, :railroad, [1, 2, 3, 4]))
  end

  defp add_dual_property_cards(cards) do
    cards
    |> Kernel.++([
      DualProperty.new(
        Property.new(4, :blue, [3, 8]),
        Property.new(4, :green, [2, 4, 7])
      )
    ])
    |> Kernel.++([
      DualProperty.new(
        Property.new(4, :green, [2, 4, 7]),
        Property.new(2, :railroad, [1, 2, 3, 4])
      )
    ])
    |> Kernel.++([
      DualProperty.new(
        Property.new(2, :utility, [1, 2]),
        Property.new(2, :railroad, [1, 2, 3, 4])
      )
    ])
    |> Kernel.++([
      DualProperty.new(
        Property.new(1, :light_blue, [1, 2, 3]),
        Property.new(2, :railroad, [1, 2, 3, 4])
      )
    ])
    |> Kernel.++([
      DualProperty.new(
        Property.new(1, :light_blue, [1, 2, 3]),
        Property.new(1, :brown, [1, 2])
      )
    ])
    |> Kernel.++(
      for _ <- 1..2,
          do:
            DualProperty.new(
              Property.new(2, :pink, [1, 2, 4]),
              Property.new(2, :orange, [1, 3, 5])
            )
    )
    |> Kernel.++(
      for _ <- 1..2,
          do:
            DualProperty.new(
              Property.new(3, :red, [2, 3, 6]),
              Property.new(3, :yellow, [2, 4, 6])
            )
    )
  end
end
