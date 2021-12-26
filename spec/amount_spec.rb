require "spec_helper"

require "amount"

describe Amount do
  describe ".format_quantity" do
    it "should convert 1.125 to 1 1/8" do
      assert_equal "1⅛", Amount.format_quantity(1.125)
    end

    it "should convert 1.25 to 1 1/4" do
      assert_equal "1¼", Amount.format_quantity(1.25)
    end

    it "should convert 1.333333 to 1 1/3" do
      assert_equal "1⅓", Amount.format_quantity(1.333333)
    end

    it "should convert 1.5 to 1 1/2" do
      assert_equal "1½", Amount.format_quantity(1.5)
    end

    it "should convert 1.666666 to 1 2/3" do
      assert_equal "1⅔", Amount.format_quantity(1.666666)
    end

    it "should convert 1.75 to 1 3/4" do
      assert_equal "1¾", Amount.format_quantity(1.75)
    end

    it "should remove leading zeros" do
      assert_equal "⅔", Amount.format_quantity(0.666666)
    end

    it "should not put a 0 in front of 1/4" do
      assert_equal "¼", Amount.format_quantity(Rational("1/4"))
    end

    it "should return a decimal value when it doesn't have a matching fraction" do
      assert_equal "1.4", Amount.format_quantity(1.4)
    end

    it "should return a decimal value when it doesn't have a matching fraction" do
      assert_equal "1.6", Amount.format_quantity(1.6)
    end
  end

  describe ".from_cooklang" do
    subject { Amount.from_cooklang(str) }

    describe "when string is empty" do
      let(:str) { "" }

      it "should have a quantity of 'some'" do
        assert_equal "some", subject.quantity
      end

      it "should have no units" do
        assert_nil subject.unit
      end
    end

    describe "when string has divider but nothing else" do
      let(:str) { "%" }

      it "should return a quantity of 'some'" do
        assert_equal "some", subject.quantity
      end

      it "should have no units" do
        assert_nil subject.unit
      end
    end

    describe "when string has divider with whitespace on either side" do
      let(:str) { " % " }

      it "should return a quantity of 'some'" do
        assert_equal "some", subject.quantity
      end

      it "should have no units" do
        assert_nil subject.unit
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

    describe "when quantity is blank but unit is present" do
      let(:str) { "%pinch" }

      it "should have a blank quantity" do
        assert_empty subject.quantity
      end

      it "should have the unit it was given" do
        assert_equal "pinch", subject.unit
      end
    end

    describe "when no unit is provided" do
      let(:str) { "three" }

      it "should have a nil unit" do
        assert_nil subject.unit
      end
    end

    describe "when a fraction is provided with whitespace" do
      let(:str) { "1 / 2" }

      it "should properly parse the number" do
        assert_equal 0.5, subject.quantity
      end
    end

    describe "when quantity is blank and default quantity is provided" do
      it "should use the provided quantity" do
        assert_equal(
          144,
          Amount.from_cooklang(
            "%minutes",
            default_quantity: 144,
          ).quantity,
        )
      end
    end
  end
end
