require "minitest/autorun"
require "minitest/reporters"
require "pry-byebug"

Minitest::Reporters.use!([
  Minitest::Reporters::DefaultReporter.new(:color => true)
])
