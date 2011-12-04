class Persona
  attr_accessor :nombre
  attr_accessor :dni
  attr_accessor :cuit

  def dni=(value)
    @dni = value.scan(/\d+/).join("")
  end

  def cuit=(value)
    @cuit = value.scan(/\d+/).join("")
  end

  def to_s
    parts = [nombre]

    parts << "DNI #{dni}" if dni && !dni.empty?
    parts << "CUIT #{cuit}" if cuit && !cuit.empty?

    parts.join(" ")
  end
end
