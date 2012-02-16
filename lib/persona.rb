class Persona
  attr_accessor :nombre
  attr_accessor :dni
  attr_accessor :cuit

  def dni=(value)
    @dni = value.scan(/\d+/).join("") if value
  end

  def cuit=(value)
    @cuit = value.scan(/\d+/).join("") if value
  end

  def to_s
    parts = [nombre]

    parts << "DNI #{dni}" if dni && !dni.empty?
    parts << "CUIT #{cuit}" if cuit && !cuit.empty?

    parts.join(" ")
  end

  def self.to_xapian_fu_storage_value(value)
    [value.nombre, value.dni, value.cuit].join(" ||| ")
  end

  def self.from_xapian_fu_storage_value(value)
    nombre, dni, cuit = value.split(" ||| ")

    Persona.new.tap do |p|
      p.nombre = nombre
      p.dni = dni
      p.cuit = cuit
    end
  end
end
