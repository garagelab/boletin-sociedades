require 'xapian-fu'


class BoletinDB < XapianFu::XapianDb
  def initialize(dir="/tmp/boletin_db")
    super(:dir => dir,
          :create => true,
          :fields => { 
            :persona_nombre => { :store => true },
            :persona_dni => { :store => true },
            :persona_cuit => { :store => true },
            :sociedad_nombre => { :store => true },
            :sociedad_tipo => { :store => true },
            :sociedad_fecha_aparicion => { :store => true },
            :sociedad_personas => { :store => true, :type => Array },
            :record_type => { :store => true }
          })
    self.rw
  end

  def store_persona(persona)
    raise "NotImplemented"
  end

  def store_sociedad(sociedad)
    raise "NotImplemented"
  end

end




