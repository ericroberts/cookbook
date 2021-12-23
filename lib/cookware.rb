require "step"

class Cookware
  def initialize(name, quantity)
    @name = name
    @quantity = quantity
  end

  attr_reader :name, :quantity

  def self.from_cooklang(str)
    name, quantity = str.split("{").map(&:strip)
    new(name, quantity&.sub("}", "") || "")
  end

  def self.parse_part(buffer)
    Step.parse_part(buffer, self)
  end

  def to_h
    {
      "type" => "cookware",
      "name" => name,
      "quantity" => quantity,
    }
  end

  def to_s
    name
  end
end

