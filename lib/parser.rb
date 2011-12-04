require_relative "sociedad"
require_relative "persona"
require_relative "palabra"
require_relative "core_ext"

class Parser
  MARKER = /^SOCIEDAD (DE RESPONSABILIDAD|ANONIMA|DEL ESTADO)/

  HALTER = /^2\.1\. CONVOCATORIAS/

  def self.parse(io, attrs = {})
    current = nil

    buffer = []

    join_next = false

    io.lines do |line|
      line = line.strip
      next if line.empty?

      break if line =~ HALTER

      if line =~ MARKER
        buffer.slice!(0..-2) if current.nil?

        if current
          current.text = buffer.slice!(0..-2).join(" ")
          yield(current)
        end

        current = Sociedad.new
        current.razon_social = buffer.delete_at(0)
        current.tipo_social = line
        attrs.each { |k, v| current.send("#{k}=", v) }

        buffer.size == 0 || (raise "Expected buffer to be empty at this point.")
      else
        if join_next
          buffer.last.slice!(-1..-1)
          buffer.last << line
        else
          buffer << line
        end

        join_next = line.end_with?("-")
      end
    end

    if current
      current.text = buffer.join(" ")
      yield(current)
    end
  end
end
