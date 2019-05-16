defmodule MonobolyDeal.Game.NameGeneratorTest do
  use ExUnit.Case, async: true

  alias MonobolyDeal.Game.NameGenerator

  describe "generate" do
    test "generates a name with a URL-friendly name such as bold-frog-8249" do
      name = NameGenerator.generate()
      name_parts = String.split(name, "-")
      assert Enum.count(name_parts) == 3
    end
  end
end
