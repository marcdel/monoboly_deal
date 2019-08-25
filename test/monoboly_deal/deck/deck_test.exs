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
    setup do
      %{deck: Deck.new()}
    end

    test "returns 106 cards", %{deck: deck} do
      count = Enum.count(deck)

      assert count == 106
    end

    test "returns 20 money cards", %{deck: deck} do
      cards = for %Money{} = card <- deck, do: card
      assert Enum.count(cards) == 20
    end

    test "returns 34 action cards", %{deck: deck} do
      cards = for %Action{} = card <- deck, do: card
      assert Enum.count(cards) == 34
    end

    test "returns 13 rent cards", %{deck: deck} do
      cards = for %Rent{} = card <- deck, do: card
      assert Enum.count(cards) == 13
    end

    test "returns 28 property cards", %{deck: deck} do
      cards = for %Property{} = card <- deck, do: card
      assert Enum.count(cards) == 28
    end

    test "returns 9 dual property cards", %{deck: deck} do
      cards = for %DualProperty{} = card <- deck, do: card
      assert Enum.count(cards) == 9
    end

    test "returns 2 property wild cards", %{deck: deck} do
      cards = for %WildProperty{} = card <- deck, do: card
      assert Enum.count(cards) == 2
    end
  end

  describe "shuffle/0" do
    test "returns the list of cards in a random order" do
      deck = Deck.new()
      shuffled_deck = Deck.shuffle(deck)
      assert Enum.count(deck) == Enum.count(shuffled_deck)
      assert deck -- shuffled_deck == []
    end
  end
end
