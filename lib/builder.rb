require "fileutils"
require "slim"

require "recipe"
require "recipe_builder"

class Builder
  def self.build
    layout = Slim::Template.new("src/templates/layout.slim")

    recipes = Dir.glob("src/recipes/*.cook").map { |f|
      Recipe.from_cookfile(f)
    }.sort_by(&:title)

    FileUtils.mkdir_p("dist/")
    File.write(
      "dist/index.html",
      layout.render { Slim::Template.new("src/templates/index.slim").render(recipes) }
    )
    puts "Index written"

    recipes.each do |recipe|
      RecipeBuilder.build(recipe, layout)
    end
  end
end
