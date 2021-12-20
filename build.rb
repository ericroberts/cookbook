require "pathname"
require "pry"
require "slim"
require "yaml"

class Recipe
  def initialize(title, hash)
    @title = title
    @hash = hash
  end

  attr_reader :title

  def self.from_path(path_string)
    path = Pathname.new(path_string)
    title = File.basename(path, ".yml").split("-").map(&:capitalize).join(" ")
    hash = YAML.load_file(path)
    new(title, hash)
  end

  def self.render(hash)
    new(hash).render
  end

  def render
    Slim::Template.new("src/templates/recipe.slim").render(self)
  end

  def ingredients
    hash.fetch("ingredients").map(&Ingredient.method(:from_hash))
  end

  def steps
    hash.fetch("steps").map(&Step.method(:from_hash))
  end

  def slug
    title.downcase.gsub(" ", "-")
  end

protected

  attr_reader :hash

  class Ingredient
    def initialize(name, amount)
      @name = name
      @amount = amount
    end

    attr_reader :name, :amount

    def self.from_hash(hash)
      new(
        hash.fetch("name"),
        hash.fetch("amount"),
      )
    end
  end

  class Step
    def initialize(description)
      @description = description
    end

    attr_reader :description

    def self.from_hash(hash)
      new(hash.fetch("description"))
    end
  end
end

layout = Slim::Template.new("src/templates/layout.slim")

recipes = Dir.glob("*.yml").map do |f|
  filename = File.basename(f, ".yml")
  Recipe.from_path(f)
end

File.write(
  "dist/index.html",
  layout.render { Slim::Template.new("src/templates/recipes.slim").render(recipes) },
)

recipes.each do |recipe|
  File.write("dist/recipes/#{recipe.slug}.html", layout.render { recipe.render })
end
