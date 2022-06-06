require "spec_helper"
require "strscan"

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

  describe "#scan" do
    subject { Ingredient.scan(buffer) }

    describe "when ingredient is single word ending in a period" do
      let(:buffer) { StringScanner.new("@sriracha.") }

      it "should return something" do
        assert_equal(Ingredient.new("sriracha", Amount.new("some")), subject)
      end
    end
  end
end
