require "filewatcher"

require "builder"
require "recipe_builder"

Filewatcher.new([
  'src/recipes/**/*.cook',
  'lib/',
  'src/templates/'
]).watch do |changed_file|
  Builder.build
end
