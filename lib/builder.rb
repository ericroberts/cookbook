require "fileutils"
require "slim"

require "parser"

class Builder
  def self.build
    FileUtils.remove_dir("dist") if File.exist?("dist")

    layout = Slim::Template.new("src/templates/layout.slim")

    recipes = Dir.glob("src/recipes/*.cook").map do |f|
      Parser.from_cookfile(f)
    end

    FileUtils.mkdir_p("dist/")
    File.write(
      "dist/index.html",
      layout.render { Slim::Template.new("src/templates/recipes.slim").render(recipes) }
    )
    puts "Index written"

    recipes.each do |recipe|
      FileUtils.mkdir_p("dist/recipes/#{recipe.slug}")
      File.write("dist/recipes/#{recipe.slug}/index.html", layout.render { recipe.render })
      puts "#{recipe.title} written"
    end

    puts "Generating CSS"
    puts system("npx tailwindcss -i ./src/input.css -o ./dist/styles.css")
  end
end
