class Timer
  def initialize(name, quantity, units)
    @name = name
    @quantity = quantity
    @units = units
  end

  attr_reader :name, :quantity, :units

  def self.from_cooklang(str)
    name, amount = str.split("{")
    quantity, units = amount.sub("}", "").split("%")
    if quantity.blank?
      new(name, 0, units)
    else
      begin
        new(name, Rational(quantity), units)
      rescue ArgumentError
        new(name, quantity, units)
      end
    end
  end

  def to_h
    {
      "type" => "timer",
      "name" => name,
      "quantity" => quantity,
      "units" => units
    }
  end
end

