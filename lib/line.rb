require "metadata"
require "step"

class Line
  def self.from_cooklang(line_str)
    if line_str.start_with?(">>")
      Metadata.from_cooklang(line_str)
    elsif line_str.start_with?("--") || line_str.blank?
      nil
    else
      Step.from_cooklang(line_str)
    end
  end
end
