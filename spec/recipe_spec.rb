require "minitest/autorun"
require "yaml"
require "recipe"

canonical = YAML.load_file("spec/canonical.yml")

describe Recipe do
  describe "canonical" do
    tests = canonical.fetch("tests").to_a
    if tests.any? { |_, t| t.fetch("focus", false) }
      tests = tests.select { |_, t| t.fetch("focus", false) }
    end
    tests.each do |name, test|
      it(name) do
        assert_equal(
          test.fetch("result"),
          Recipe.from_cooklang(name, test.fetch("source")).to_h,
        )
      end
    end
  end

  describe "additional tests" do
    it "should handle ingredient without {} and subsequent ingredients" do
      assert_equal(
        {
          "steps" => [
            [{
              "type" => "text",
              "value" => "Put "
            }, {
              "type" => "ingredient",
              "name" => "salt",
              "quantity" => "some",
              "units" => "",
            }, {
              "type" => "text",
              "value" => " and ",
            }, {
              "type" => "ingredient",
              "name" => "pepper",
              "quantity" => 1,
              "units" => "tsp",
            }, {
              "type" => "text",
              "value" => " in the pan and push it.",
            }]
          ],
          "metadata" => [],
        },
        Recipe
          .from_cooklang(
            "Recipe title",
            "Put @salt and @pepper{1%tsp} in the pan and push it.",
          ).to_h
      )
    end

    it "should handle cookware without {} and subsequent ingredients" do
      assert_equal(
        {
          "steps" => [
            [{
              "type" => "text",
              "value" => "Into the "
            }, {
              "type" => "cookware",
              "name" => "pan",
              "quantity" => "",
            }, {
              "type" => "text",
              "value" => " put the ",
            }, {
              "type" => "ingredient",
              "name" => "tomatoes",
              "quantity" => 3,
              "units" => "cups",
            }]
          ],
          "metadata" => [],
        },
        Recipe.from_cooklang(
          "Recipe title",
          "Into the #pan put the @tomatoes{3%cups}",
        ).to_h
      )
    end

    it "should be able handle hyphenated words" do
      assert_equal(
        {
          "steps" => [
            [{
              "type" => "text",
              "value" => "This is a step with a hyphenated-word."
            }],
          ],
          "metadata" => [],
        },
        Recipe.from_cooklang(
          "Recipe title",
          "This is a step with a hyphenated-word.",
        ).to_h,
      )
    end
  end
end
