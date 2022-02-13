require "active_support/core_ext/object/blank"
require "pathname"
require "slim"

require "line"

class Recipe
  def initialize(title, steps, metadata)
    @title = title
    @steps = steps
    @metadata = metadata
  end

  attr_reader :title, :steps, :metadata

  def self.from_cookfile(path_string)
    path = Pathname.new(path_string)
    title = File.basename(path, ".cook").split("-").map(&:capitalize).join(" ")
    from_cooklang(title, File.read(path))
  end

  def self.from_cooklang(title, recipe_str)
    lines =
      recipe_str
        .split(/\n/)
        .map(&Line.method(:from_cooklang))

    new(
      title,
      lines.select { |l| l.is_a?(Step) },
      lines.select { |l| l.is_a?(Metadata) },
    )
  end

  def slug
    title.downcase.gsub(" ", "-")
  end

  def render
    Slim::Template.new("src/templates/recipe.slim").render(self)
  end

  def ingredients
    steps.flat_map(&:ingredients).group_by(&:name).map do |name, is|
      Ingredient.new(name, is.map(&:amount))
    end
  end

  def to_h
    {
      "steps" => steps.map(&:to_h),
      "metadata" => metadata_hash,
    }
  end

protected

  def metadata_hash
    if metadata.any?
      metadata.reduce({}) do |metadata_hash, metadata_line|
        metadata_hash.merge(metadata_line.key => metadata_line.value)
      end
    else
      []
    end
  end
end
