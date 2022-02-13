class Metadata
  def initialize(key, value)
    @key = key
    @value = value
  end

  attr_reader :key, :value

  def self.from_cooklang(str)
    key, value = str.split(":", 2).map(&:strip)
    new(key.sub(/\A>>\s?/, ""), value)
  end
end

