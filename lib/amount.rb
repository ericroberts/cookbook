class NullAmount
  def quantity
    "some"
  end

  def unit
    ""
  end

  def to_s
    quantity
  end
end

class Amount
  def initialize(quantity, unit)
    @quantity = quantity
    @unit = unit
  end

  attr_reader :quantity, :unit

  def self.from_cooklang(str)
    quantity, unit = str.split("%")
    if quantity.blank? && unit.blank?
      NullAmount.new
    elsif quantity.blank? && unit.present?
      new("", unit.strip)
    elsif quantity.start_with?("0")
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
    "#{quantity.to_f} #{unit}"
  end
end
