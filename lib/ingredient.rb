require "forwardable"

require "amount"
require "scan"
require "step"

class Ingredient
  extend Scan
  extend Forwardable

  def initialize(name, amount)
    @name = name
    @amount = amount
  end

  attr_reader :name, :amount

  def_delegators :amount, :quantity, :unit

  def self.from_cooklang(str)
    name, amount = str.split("{")

    new(
      name,
      Amount.from_cooklang(amount.to_s.sub("}", "")),
    )
  end

  def to_s
    "#{name} (#{amount})"
  end

  def to_h
    {
      "type" => "ingredient",
      "name" => name,
    }.merge(amount.to_h)
  end

  def ==(other)
    other.is_a?(Ingredient) && other.name == name && other.amount == amount
  end
end
