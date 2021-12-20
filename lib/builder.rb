require "fileutils"
require "slim"
require_relative "recipe"

class Builder
  def self.build
    puts "generating CSS"
    puts system("npx tailwindcss -i ./src/input.css -o ./dist/styles.css")

    layout = Slim::Template.new("src/templates/layout.slim")

    recipes = Dir.glob("src/recipes/*.yml").map do |f|
      filename = File.basename(f, ".yml")
      Recipe.from_path(f)
    end

    File.write(
      "dist/index.html",
      layout.render { Slim::Template.new("src/templates/recipes.slim").render(recipes) },
    )

    puts "Index written"

    recipes.each do |recipe|
      FileUtils.mkdir_p "dist/recipes/#{recipe.slug}"
      File.write("dist/recipes/#{recipe.slug}/index.html", layout.render { recipe.render })
      puts "#{recipe.slug} written"
    end
  end
end
