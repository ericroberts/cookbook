require "amount"
require "step"

class Ingredient
  def initialize(name, amount)
    @name = name
    @amount = amount
  end

  attr_reader :name, :amount

  def self.from_cooklang(str)
    name, amount = str.split("{")
    if amount
      new(
        name,
        Amount.from_cooklang(amount.sub("}", "")),
      )
    else
      new(
        name,
        NullAmount.new,
      )
    end
  end

  def self.parse_part(buffer)
    Step.parse_part(buffer, self)
  end

  def to_s
    "#{name}"
  end

  def quantity
    amount.quantity
  end

  def unit
    amount.unit
  end

  def to_h
    {
      "type" => "ingredient",
      "name" => name,
      "quantity" => quantity,
      "units" => unit,
    }
  end
end

