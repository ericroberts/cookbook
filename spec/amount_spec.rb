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

    it "should not put a 0 in front of 1/4" do
      assert_equal "¼", Amount.format_fraction(Rational("1/4"))
    end

    it "should return a decimal value when it doesn't have a matching fraction" do
      assert_equal "1.4", Amount.format_fraction(1.4)
    end
  end

  describe ".from_cooklang" do
    subject { Amount.from_cooklang(str) }

    describe "when string is empty" do
      let(:str) { "" }

      it "should return a Some" do
        assert_kind_of Some, subject
      end
    end

    describe "when string has divider but nothing else" do
      let(:str) { "%" }

      it "should return a Some" do
        assert_kind_of Some, subject
      end
    end

    describe "when string has divider with whitespace on either side" do
      let(:str) { " % " }

      it "should return a Some" do
        assert_kind_of Some, subject
      end
    end

    describe "when quantity starts with 0 and looks like a fraction" do
      let(:str) { "01/2" }

      it "should pass the quantity through unchanged" do
        assert_equal "01/2", subject.quantity
      end
    end

    describe "when quantity starts with 0 and is a decimal" do
      let(:str) { "0.25" }

      it "should convert it to a number" do
        assert_equal 0.25, subject.quantity
      end
    end

    describe "when quantity is not a number" do
      let(:str) { "a few%dollops" }

      it "should pass it through unchanged" do
        assert_equal "a few", subject.quantity
      end
    end
  end
end
