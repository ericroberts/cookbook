require "strscan"

require "cookware"
require "ingredient"
require "text"
require "timer"

class Step
  def initialize(parts)
    @parts = parts
  end

  attr_reader :parts

  def self.from_cooklang(step_str)
    buffer = StringScanner.new(step_str)
    parts = []
    until buffer.eos?
      part_type = {
        "@" => Ingredient,
        "#" => Cookware,
        "~" => Timer,
      }.fetch(buffer.peek(1), Text)

      parts << part_type.scan(buffer)
    end

    new(parts)
  end

  def ingredients
    @ingredients ||= parts.select { |p| p.is_a?(Ingredient) }
  end

  def description
    @description ||= parts.map(&:to_s).join
  end

  def empty?
    parts.empty?
  end

  def to_h
    parts.map(&:to_h)
  end
end
