require "amount"
require "scan"
require "step"

class Ingredient
  extend Scan

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
        Some.new,
      )
    end
  end

  def to_s
    "#{name}"
  end

  def to_h
    {
      "type" => "ingredient",
      "name" => name,
    }.merge(amount.to_h)
  end
end

