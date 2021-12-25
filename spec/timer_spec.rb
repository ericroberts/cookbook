require "timer"

describe Timer do
  let(:timer) { Timer.new("name", amount) }
  let(:amount) { Amount.new(quantity, units) }

  describe "#to_s" do
    subject { timer.to_s }
    let(:quantity) { Rational("20") }
    let(:units) { "minutes" }

    describe "when rational number that is an integer is given" do
      it "should not print the denominator" do
        assert_equal "20 minutes", subject
      end
    end
  end
end
