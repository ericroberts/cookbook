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
      if buffer.peek(1) == "@"
        parts << parse_part(buffer, Ingredient)
      elsif buffer.peek(1) == "#"
        parts << parse_part(buffer, Cookware)
      elsif buffer.peek(1) == "~"
        parts << parse_part(buffer, Timer)
      elsif buffer.peek(2) == "--"
        buffer.skip_until(/\n|\Z/)
      else
        text = buffer.scan_until(/^([^@#~\n\Z])*/).sub(/--.*/, "")
        parts << Text.from_cooklang(text)
      end
    end

    new(parts)
  end

  def self.parse_part(buffer, part_type)
    buffer.getch
    possible_part = buffer.check_until(/}/)
    if possible_part.nil? || possible_part.match?(/@|#|~/)
      part_type.from_cooklang(buffer.scan_until(/^[^\s]*/))
    else
      part_type.from_cooklang(buffer.scan_until(/}/))
    end
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
