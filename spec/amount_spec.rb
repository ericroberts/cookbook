require "spec_helper"

require "amount"

describe Amount do
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

  describe "#to_s" do
    subject { amount.to_s }
    let(:amount) { Amount.new(quantity, unit) }

    describe "when quantity is some and unit is nil" do
      let(:quantity) { "some" }
      let(:unit) { nil }

      it "should return just the string 'some' with no whitespace on either side" do
        assert_equal(quantity, subject.to_s)
      end
    end
  end
end
