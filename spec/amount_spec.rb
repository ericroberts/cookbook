require "spec_helper"

require "amount"

describe Amount do
  describe ".format_fraction" do
    it "should convert 1.125 to 1 1/8" do
      assert_equal "1⅛", Amount.format_fraction(1.125)
    end

    it "should convert 1.25 to 1 1/4" do
      assert_equal "1¼", Amount.format_fraction(1.25)
    end

    it "should convert 1.333333 to 1 1/3" do
      assert_equal "1⅓", Amount.format_fraction(1.333333)
    end

    it "should convert 1.5 to 1 1/2" do
      assert_equal "1½", Amount.format_fraction(1.5)
    end

    it "should convert 1.666666 to 1 2/3" do
      assert_equal "1⅔", Amount.format_fraction(1.666666)
    end

    it "should convert 1.75 to 1 3/4" do
      assert_equal "1¾", Amount.format_fraction(1.75)
    end

    it "should remove leading zeros" do
      assert_equal "⅔", Amount.format_fraction(0.666666)
    end

    it "should work with 1/4" do
      assert_equal "¼", Amount.format_fraction(Rational("1/4"))
    end

    it "should return a decimal value when it doesn't have a matching fraction" do
      assert_equal "1.4", Amount.format_fraction(1.4)
    end
  end
end
