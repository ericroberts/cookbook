require "active_support/core_ext/object/blank"
require "pry"
require "strscan"

class Parser
  def initialize(recipe_str)
    @lines =
      recipe_str
        .split(/\n/)
        .map(&LineParser.method(:parse))
  end

  attr_reader :lines

  def to_h
    {
      "steps" => step_lines.map(&:to_h),
      "metadata" => metadata_hash,
    }
  end

  def metadata_hash
    if metadata_lines.any?
      metadata_lines.reduce({}) do |metadata_hash, metadata_line|
        metadata_hash.merge(metadata_line.key => metadata_line.value)
      end
    else
      []
    end
  end

protected

  def metadata_lines
    lines.select { |l| l.is_a?(Metadata) }
  end

  def step_lines
    lines.select { |l| l.is_a?(StepParser) }.reject(&:empty?)
  end
end

class LineParser
  def self.parse(str)
    if str.start_with?(">>")
      Metadata.from_cooklang(str)
    else
      StepParser.new(str)
    end
  end
end

class StepParser
  def initialize(step_str)
    @buffer = StringScanner.new(step_str)
    @parts = []
    parse
  end

  attr_reader :metadata

  def parse
    until @buffer.eos?
      if @buffer.peek(1) == "@"
        @parts << parse_part(Ingredient)
      elsif @buffer.peek(1) == "#"
        @parts << parse_part(Cookware)
      elsif @buffer.peek(1) == "~"
        @parts << parse_part(Timer)
      elsif @buffer.peek(2) == "--"
        @buffer.skip_until(/\n|\Z/)
      else
        @parts << Text.from_cooklang(@buffer.scan_until(/^[^@#~\-\n\Z]*/))
      end
    end
  end

  def parse_part(part_type)
    @buffer.getch
    possible_part = @buffer.check_until(/}/)
    if possible_part.nil? || possible_part.match?(/@|#|~/)
      part_type.from_cooklang(@buffer.scan_until(/^[^\s]*/))
    else
      part_type.from_cooklang(@buffer.scan_until(/}/))
    end
  end

  def empty?
    @parts.empty?
  end

  def to_h
    @parts.map(&:to_h)
  end
end

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

  def to_s
    "#{name} #{amount}"
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

class NullAmount
  def quantity
    "some"
  end

  def unit
    ""
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
    "#{quantity}#{unit}"
  end
end

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

  def to_h
    {
      "type" => "cookware",
      "name" => name,
      "quantity" => quantity,
    }
  end
end

class Metadata
  def initialize(key, value)
    @key = key
    @value = value
  end

  attr_reader :key, :value

  def self.from_cooklang(str)
    key, value = str.split(":").map(&:strip)
    new(key.sub(/\A>>\s?/, ""), value)
  end
end

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

class Text
  def initialize(text)
    @text = text
  end

  attr_reader :text

  def self.from_cooklang(str)
    new(str)
  end

  def to_h
    {
      "type" => "text",
      "value" => text,
    }
  end
end
