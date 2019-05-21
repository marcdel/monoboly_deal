defmodule MonobolyDeal.Deck.Action do
  alias MonobolyDeal.Deck.Action

  @derive {Jason.Encoder, only: [:name, :type, :value]}
  @enforce_keys [:name, :type, :value]
  defstruct [:name, :type, :value]

  def new(value, type) do
    %Action{name: :action_card, value: value, type: type}
  end
end
