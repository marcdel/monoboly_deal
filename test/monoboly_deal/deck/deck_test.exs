defmodule MonobolyDeal.DeckTest do
  use ExUnit.Case, async: true

  alias MonobolyDeal.Deck

  alias MonobolyDeal.Deck.{
    Money,
    Action,
    Rent,
    Property,
    DualProperty,
    WildProperty
  }

  describe "cards/0" do
    test "returns 106 cards" do
      count =
        Deck.cards()
        |> Enum.count()

      assert count == 106
    end

    test "returns 20 money cards" do
      cards = for %Money{} = card <- Deck.cards(), do: card
      assert Enum.count(cards) == 20
    end

    test "returns 34 action cards" do
      cards = for %Action{} = card <- Deck.cards(), do: card
      assert Enum.count(cards) == 34
    end

    test "returns 13 rent cards" do
      cards = for %Rent{} = card <- Deck.cards(), do: card
      assert Enum.count(cards) == 13
    end

    test "returns 28 property cards" do
      cards = for %Property{} = card <- Deck.cards(), do: card
      assert Enum.count(cards) == 28
    end

    test "returns 9 dual property cards" do
      cards = for %DualProperty{} = card <- Deck.cards(), do: card
      assert Enum.count(cards) == 9
    end

    test "returns 2 property wild cards" do
      cards = for %WildProperty{} = card <- Deck.cards(), do: card
      assert Enum.count(cards) == 2
    end
  end

  describe "shuffle/0" do
    test "returns the list of cards in a random order" do
      assert Deck.cards() -- Deck.shuffle() == []
    end
  end
end
