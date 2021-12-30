require "fileutils"

require "recipe"

class RecipeBuilder
  def self.build_from_file(path_string)
    build(Recipe.from_cookfile(path_string))
  end

  def self.build(recipe, layout = Slim::Template.new("src/templates/layout.slim"))
    FileUtils.mkdir_p("dist/recipes/#{recipe.slug}")
    File.write("dist/recipes/#{recipe.slug}/index.html", layout.render { recipe.render })
    puts "#{recipe.title} built"
  end
end
