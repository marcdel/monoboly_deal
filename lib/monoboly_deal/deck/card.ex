defmodule MonobolyDeal.Deck.Card do
  def generate_id do
    "#{:rand.uniform()}"
  end
end
