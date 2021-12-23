module Scan
  def scan(buffer)
    buffer.getch
    possible_part = buffer.check_until(/}/)
    if possible_part.nil? || possible_part.match?(/@|#|~/)
      from_cooklang(buffer.scan_until(/^[^\s]*/))
    else
      from_cooklang(buffer.scan_until(/}/))
    end
  end
end
