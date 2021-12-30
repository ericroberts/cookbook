require "active_support/core_ext/object/blank"
require "fractional"

class Amount
  def initialize(quantity, unit = nil)
    @quantity = quantity
    @unit = unit
  end

  attr_reader :quantity, :unit

  def self.from_cooklang(str, default_quantity: "")
    quantity, unit = str.split("%").map(&:strip)
    if quantity.blank? && unit.blank?
      new("some")
    elsif quantity.blank? && unit.present?
      new(default_quantity, unit)
    elsif quantity.start_with?("0") && quantity.include?("/")
      # This is for testFractionsLike from canonical.yml. I don't necessarily
      # agree with this rule. I needed to have `quantity.include("/")` because
      # otherwise it would break parsing for 0.25. This rule still seems crappy
      # to me, ideally I'll figure out something better later.
      new(quantity, unit)
    else
      begin
        new(Rational(quantity.gsub(/\s+/, "")), unit)
      rescue ArgumentError
        new(quantity, unit)
      end
    end
  end

  def to_s
    if quantity.is_a?(Numeric)
      "#{Fractional.new(quantity).to_s(mixed_number: true)} #{unit}"
    else
      "#{quantity} #{unit}"
    end
  end

  def to_h
    {
      "quantity" => quantity,
      "units" => unit.to_s,
    }
  end
end
