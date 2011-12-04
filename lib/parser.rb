require_relative "sociedad"
require_relative "persona"
require_relative "palabra"
require_relative "core_ext"

class Parser
  MARKER = "SOCIEDAD ANONIMA"

  def self.parse(io)
    current = nil

    buffer = []

    io.lines do |line|
      line = line.strip
      next if line.empty?

      if line == MARKER
        buffer.slice!(0..-2) if current.nil?

        if current
          current.text = buffer.slice!(0..-2).join(" ")
          yield(current)
        end

        current = Sociedad.new
        current.razon_social = buffer.delete_at(0)

        buffer.size == 0 || (raise "Expected buffer to be empty at this point.")
      else
        buffer << line
      end
    end

    if current
      current.text = buffer.slice!(0..-2).join(" ")
      yield(current)
    end
  end
end
