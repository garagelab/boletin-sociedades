require 'xapian-fu'


class BoletinDB < XapianFu::XapianDb
  def initialize(dir="/tmp/boletin_db")
    super(:dir => dir,
          :create => true,
          :fields => { 
            :persona_nombre => { :store => true },
            :persona_dni => { :store => true },
            :persona_cuit => { :store => true },
            :sociedad_razon_social => { :store => true },
            :sociedad_tipo_social => { :store => true },
            :sociedad_fecha_aparicion => { :store => true },
            :sociedad_personas => { :store => true, :type => Array },
            :sociedad_text => { :store => true },
            :record_type => { :store => true }
          })
    self.rw
  end

  def store_sociedad(sociedad)
    
    personas = sociedad.personas.map { |p|
      { 
        :record_type => "Persona",
        :persona_nombre => p.nombre,
        :persona_dni => p.dni,
        :persona_cuit => p.cuit
      }
    }

    # TODO store a list of things without looping here?
    personas.each { |p| self << p }

    self << { 
      :record_type => "Sociedad",
      :sociedad_razon_social => sociedad.razon_social,
      :sociedad_tipo_social => sociedad.tipo_social,
      :sociedad_fecha_aparicion => sociedad.fecha_aparicion,
      :sociedad_personas => personas,
      :sociedad_text => sociedad.text 
    }


  end




end




