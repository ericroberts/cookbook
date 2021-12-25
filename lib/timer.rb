require "amount"
require "step"
require "scan"

class Timer
  extend Scan

  def initialize(name, amount)
    @name = name
    @amount = amount
  end

  attr_reader :name, :amount

  def self.from_cooklang(str)
    name, amount_str = str.split("{")
    amount = Amount.from_cooklang(
      amount_str.sub(/\}\Z/, ""),
      default_quantity: 0,
    )
    new(name, amount)
  end

  def to_h
    {
      "type" => "timer",
      "name" => name,
    }.merge(amount.to_h)
  end

  def to_s
    "#{amount.quantity} #{amount.units}"
  end
end

