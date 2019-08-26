defmodule MonobolyDealWeb.GameView do
  use MonobolyDealWeb, :view

  def card_classes(game_state, card, index) do
    chosen_card_class = if card_chosen(game_state, card), do: "chosen-card", else: ""
    "card hand-card#{index + 1} #{chosen_card_class}"
  end

  defp card_chosen(game_state, card) do
    game_state.current_turn != nil &&
      game_state.current_turn.chosen_card != nil &&
      game_state.current_turn.chosen_card.id == card.id
  end
end
