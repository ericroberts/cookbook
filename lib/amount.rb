require "active_support/core_ext/object/blank"

class Some
  def quantity
    "some"
  end

  def unit
    ""
  end

  def to_s
    quantity
  end

  def ==(other)
    other.is_a?(Some)
  end
end

class None
end

class Amount
  def initialize(quantity, unit)
    @quantity = quantity
    @unit = unit
  end

  attr_reader :quantity, :unit

  FRACTIONS = {
    1/8r => "⅛",
    1/4r => "¼",
    1/3r => "⅓",
    1/2r => "½",
    2/3r => "⅔",
    3/4r => "¾",
  }

  def self.format_fraction(number)
    fix, frac = number.rationalize(0.01).divmod(1)
    fraction = FRACTIONS[frac]
    if fraction
      if fix != 0
        [fix, FRACTIONS[frac]].join
      else
        FRACTIONS[frac]
      end
    elsif number.is_a?(Rational) && number.denominator == 1
      number.to_i
    else
      number.to_f.to_s
    end
  end

  def self.from_cooklang(str)
    quantity, unit = str.split("%")
    if quantity.blank? && unit.blank?
      Some.new
    elsif quantity.blank? && unit.present?
      new("", unit.strip)
    elsif quantity.start_with?("0") && quantity.include?("/")
      # This is for testFractionsLike from canonical.yml. I don't necessarily
      # agree with this rule. I needed to have `quantity.include("/")` because
      # otherwise it would break parsing for 0.25. This rule still seems crappy
      # to me, ideally I'll figure out something better later.
      new(quantity, unit&.strip)
    else
      begin
        new(Rational(quantity.gsub(/\s+/, "")), unit&.strip || "")
      rescue ArgumentError
        new(quantity.strip, unit&.strip || "")
      end
    end
  end

  def to_s
    if quantity.is_a?(Numeric)
      "#{self.class.format_fraction(quantity)} #{unit}"
    else
      "#{quantity} #{unit}"
    end
  end
end
