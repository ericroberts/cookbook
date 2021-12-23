class Text
  def initialize(text)
    @text = text
  end

  attr_reader :text

  def self.from_cooklang(str)
    new(str)
  end

  def self.scan(buffer)
    from_cooklang(
      buffer.scan_until(/^([^@#~\n\Z])*/).sub(/--.*/, "")
    )
  end

  def to_h
    {
      "type" => "text",
      "value" => text,
    }
  end

  def to_s
    text
  end
end
