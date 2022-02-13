require "spec_helper"

require "ingredient"

describe Ingredient do
  let(:ingredient) { Ingredient.new(ingredient_name, amount) }
  let(:ingredient_name) { "Water" }
  let(:amount) { Amount.new(100, "g") }

  describe "#to_s" do
    subject { ingredient.to_s }

    it "should print the name and amount" do
      assert_equal "#{ingredient_name} (#{amount.to_s})", subject
    end
  end
end
