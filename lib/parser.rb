require "active_support/core_ext/object/blank"
require "strscan"

require "amount"
require "cookware"
require "ingredient"
require "metadata"
require "text"
require "timer"

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

protected

  def step_lines
    lines.select { |l| l.is_a?(StepParser) }.reject(&:empty?)
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

  def metadata_lines
    lines.select { |l| l.is_a?(Metadata) }
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
        text = @buffer.scan_until(/^([^@#~\n\Z])*/).sub(/--.*/, "")
        @parts << Text.from_cooklang(text)
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
