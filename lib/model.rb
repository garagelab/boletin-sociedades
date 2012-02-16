require 'xapian-fu'

class PersonaArray < Array
  def self.to_xapian_fu_storage_value(value)
    value.map { |item| Persona.to_xapian_fu_storage_value(item) }.join(" /// ")
  end

  def self.from_xapian_fu_storage_value(value)
    value.split(" /// ").map { |item| Persona.from_xapian_fu_storage_value(item) }
  end
end

class BoletinDB < XapianFu::XapianDb
  def initialize(dir="/tmp/boletin_db")
    super(:dir => dir,
          :create => true,
          :language => :spanish,
          :stemmer => false,
          :fields => {
            :razon_social => { :store => true },
            :tipo_social => { :store => true },
            :fecha_aparicion => { :store => true },
            :personas => { :store => true, :type => PersonaArray },
            :text => { :store => true },
          })
  end

  def store_sociedad(sociedad)
    self << {
      :razon_social => sociedad.razon_social,
      :tipo_social => sociedad.tipo_social,
      :fecha_aparicion => sociedad.fecha_aparicion,
      :personas => sociedad.personas,
      :text => sociedad.text
    }
  end
end
