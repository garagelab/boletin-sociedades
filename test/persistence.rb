# encoding: UTF-8


require_relative "../lib/model"
require_relative "../lib/sociedad"

require "test/unit"

DB_DIR = "/tmp/boletino"

class SociedadTest < Test::Unit::TestCase

  def test_db_creation
    bdb = create_db
    assert File.exists?(DB_DIR)
    bdb.rw.close
    destroy_db
  end

  def test_record_creation
    bdb = create_db
    bdb << (r = { :persona_nombre => "Juan Carlos Petruza", :record_type => "Persona" })
    bdb.flush
    s = bdb.search("petruza")

    assert s.size == 1
    assert s.first.values["persona_nombre"] == r[:persona_nombre]
    bdb.rw.close
    destroy_db
  end


  def test_sociedad_storage
    bdb = create_db
    
    s = Sociedad.new
    s.text = "Constitución SA: Escritura 385 del 14/10/11, ante Esc. Adrián Comas Reg. 159 CABA. Socios: (argentinos, solteros, empresarios, domicilio  real/especial) Emiliano Stupak,  18/12/77, DNI 26.353.275,  Av  Pte.  Perón  6125,  Martín Coronado, Tres de Febrero, Prov Bs As (Presidente); y Hernán Carlos Lorenzo, 27/7/77, DNI 25.683.435, Cosme Gaviña 2196, Ituzaingó, Prov Bs As (Director Suplente). Sede: Sarmiento 1652, piso 2, unidad âEâ, C.A.B.A. Plazo: 99 años. Objeto:  La explotación  como  Empresa de los rubros: industrial y comercial, relacionados únicamente con todo tipo de artículos de ferretería, electricidad y sanitarios en general; consistente en la industrialización, fabricación, producción, comercialización, compra, venta, con o sin financiación, locación, importación, exportación  y representación  al por  mayor y menor de materias primas, productos, subproductos, sus partes, repuestos, insumos, accesorios  y componentes  relacionados con  lo indicado  al principio. Toda actividad  que así lo  requiera  será  realizada  por  profesionales con  título  habilitante  en  la  materia. Capital: $ 20.000.Directorio: 1 a 5, por 3 años. Representación: Presidente. Sin Sindicatura. Cierre: 31/12. (Autorizado por escritura referida).  Escribano Adrián Carlos Comas e. 21/10/2011 N° 135473/11 v. 21/10/2011"
    
    bdb.store_sociedad(s)

    assert bdb.search("record_type:Persona").size == 6
    assert bdb.search("record_type:Sociedad").size == 1


  end

  private 

  def create_db
    BoletinDB.new(DB_DIR)
  end

  def destroy_db
    system "rm -rf #{DB_DIR}"
  end

end
