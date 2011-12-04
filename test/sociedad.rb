# encoding: UTF-8

require_relative "../lib/parser"

require "test/unit"

class SociedadTest < Test::Unit::TestCase
  def test_personas
    s = Sociedad.new
    s.text = "Constitución SA: Escritura 385 del 14/10/11, ante Esc. Adrián Comas Reg. 159 CABA. Socios: (argentinos, solteros, empresarios, domicilio  real/especial) Emiliano Stupak,  18/12/77, DNI 26.353.275,  Av  Pte.  Perón  6125,  Martín Coronado, Tres de Febrero, Prov Bs As (Presidente); y Hernán Carlos Lorenzo, 27/7/77, DNI 25.683.435, Cosme Gaviña 2196, Ituzaingó, Prov Bs As (Director Suplente). Sede: Sarmiento 1652, piso 2, unidad âEâ, C.A.B.A. Plazo: 99 años. Objeto:  La explotación  como  Empresa de los rubros: industrial y comercial, relacionados únicamente con todo tipo de artículos de ferretería, electricidad y sanitarios en general; consistente en la industrialización, fabricación, producción, comercialización, compra, venta, con o sin financiación, locación, importación, exportación  y representación  al por  mayor y menor de materias primas, productos, subproductos, sus partes, repuestos, insumos, accesorios  y componentes  relacionados con  lo indicado  al principio. Toda actividad  que así lo  requiera  será  realizada  por  profesionales con  título  habilitante  en  la  materia. Capital: $ 20.000.Directorio: 1 a 5, por 3 años. Representación: Presidente. Sin Sindicatura. Cierre: 31/12. (Autorizado por escritura referida).  Escribano Adrián Carlos Comas e. 21/10/2011 N° 135473/11 v. 21/10/2011"

    nombres = s.personas.map(&:nombre)

    assert nombres.include?("Emiliano Stupak")
    assert nombres.include?("Hernán Carlos Lorenzo")

    assert_equal "26353275", s.personas.detect { |p| p.nombre == "Emiliano Stupak" }.dni

    s = Sociedad.new
    s.text = "Néstor Guillermo Rodríguez Certificación emitida por: Susana M. Petrelli. N° Registro: 1028. N° Matrícula:  2996. Fecha:"

    nombres = s.personas.map(&:nombre)

    assert_equal ["Néstor Guillermo Rodríguez", "Susana M. Petrelli"], nombres
  end

  def test_personas_con_nombre_con_artículos
    s = Sociedad.new
    s.text = "Constitución SA: el Abogado Paula del Campo"

    nombres = s.personas.map(&:nombre)

    assert_equal ["Paula del Campo"], nombres
  end

  def test_personas_y_no_calles
    s = Sociedad.new
    s.text = "Constitución SA: Abogada Paula del Campo, Quintana 520"

    assert s.personas.map(&:nombre).grep(/Quintana/).empty?
  end

  def test_personas_y_no_incisos
    s = Sociedad.new
    s.text = "ambos argentinos y comerciantes. 2) Escritura del 7/10/11. 3) A.C.A.G. . 4) Carlos Pellegrini"

    assert_equal ["Carlos Pellegrini"], s.personas.map(&:nombre)
  end

  def test_personas_y_no_articulos
    s = Sociedad.new
    s.text = "Constitución SA: orden de la jornada"

    assert_equal [], s.personas.map(&:nombre)

    s = Sociedad.new
    s.text = "Constitución SA: saber por un día que"

    assert_equal [], s.personas.map(&:nombre)

    s = Sociedad.new
    s.text = "Constitución SA: La Saber"

    assert_equal [], s.personas.map(&:nombre)

    s = Sociedad.new
    s.text = "Constitución SA: Diego de la Vega"

    assert_equal ["Diego de la Vega"], s.personas.map(&:nombre)
  end

  def test_personas_y_no_oraciones
    s = Sociedad.new
    s.text = "Lorem ipsum dolor Ley de Sociedades Comerciales N° 19.550.â<U+0080><U+009D> Santiago Debaisieux. Presidente designado por Estatuto de fecha 03/05/11. Santiago Debaisieux sit amet"

    assert_equal ["Santiago Debaisieux"], s.personas.map(&:nombre)
  end

  def test_personas_y_no_numeros
    s = Sociedad.new
    s.text = "Risso 240 Ciudad,  Moreno 39 de la Ciudad,  Azucena Villaflor 550 Piso 19 dpto 1 C, el Presidente Hugo Alberto Borrell,  Belgrano 1073 de la Ciudad "

    assert_equal ["Hugo Alberto Borrell"], s.personas.map(&:nombre)
  end

  def test_personas_separadas
    s = Sociedad.new
    s.text = "Carolina Schiappacasse y Santiago Carlos Blanco"

    assert_equal ["Carolina Schiappacasse", "Santiago Carlos Blanco"], s.personas.map(&:nombre)
  end

  def test_personas_con_iniciales
    s = Sociedad.new
    s.text = "Certificación  emitida por: Adriana P. Balda. N° Registro: 1891. N° Matrícula:  4621."

    assert_equal ["Adriana P. Balda"], s.personas.map(&:nombre)
  end

  def test_personas_solo_en_formato_nombre_y_apellido
    s = Sociedad.new
    s.text = "endosables con derecho a un voto cada acción y de valor nominal un peso ($ 1.-)  cada una. El capital podrá por decisión de la Asamblea aumentarse hasta su quíntuplo sin requerirse nueva conformidad administrativa, conforme lo dispuesto por el artículo 188 de la Ley 19.550. La asamblea fijará en cada caso las características de las acciones, pudiendo delegar en el directorio la oportunidad de las emisiones y la forma y modo de aquellas. La resolución respectiva será elevada a escritura pública, y se inscribirá en el registro Público de Comercio.â Escribana Claudia Marina Hermansson. Matricula 4127 Capital Federal, autorizada para publicar edictos por escritura 229 del 17/10/2011, Folio 757, Titular del Registro 237, C.A.B.A. "

    assert_equal ["Claudia Marina Hermansson"], s.personas.map(&:nombre)
  end

  def test_personas_sin_letras_raras
    s = Sociedad.new
    s.text = "Alejandra Zunino autorizada F°"

    assert_equal ["Alejandra Zunino"], s.personas.map(&:nombre)
  end

  def test_personas_unicas
    s = Sociedad.new
    s.text = "Damián Janowski y Damian Janowski"

    assert_equal ["Damián Janowski"], s.personas.map(&:nombre)
  end

  def test_bogus
    s = Sociedad.new
    s.text = "Capital:  El capital  social  es de Pesos Trescientos Mil representado por la cantidad  de Trescientas Mil acciones ordinarias, nominativas no endosables, de pesos uno ($ 1) valor nominal cada una y de un voto por acción.â Autorizada por Acta de Asamblea General Extraordinaria de fecha 21 de septiembre de 2011."

    assert_equal [], s.personas.map(&:nombre)
  end

  def test_personas_con_cuit
    s = Sociedad.new
    s.text = "Constitucion;  13-10-11, Esc 259, F 705, Socios:  Agustin  Salaberry, nacido  24-5-83,  DNI 30.333.445,  CUIT 23-30333445-9,  Publicista, domicilio  real  Franklin  Roosevelt  3336,  P  5, Dto.  A CABA, y Facundo García,  nacido  31 12-82, Comerciante, DNI  29.986.950,  CUIT 20-29986950-5"

    assert_equal "23303334459", s.personas.detect { |p| p.nombre == "Agustin Salaberry" }.cuit
    assert_equal "20299869505", s.personas.detect { |p| p.nombre == "Facundo García" }.cuit
  end

  def test_personas_con_dni
    s = Sociedad.new
    s.text = "Accionistas:  Matias Gonzalo Felix Oteo, 27 años, soltero, empleado, DNI: 31.070.717, Teniente Galan 2941 El Palomar, Tres de Febrero, Provincia  de  Buenos  Aires; Fernando Martín Bernat,  34  años,  casado,  comerciante,  DNI: 26.157.869, Aviador Koehl 2494 El Palomar, Tres de Febrero, Provincia de Buenos Aires; Carolina Schiappacasse, 56 años, casada, médica, DNI: 12.045.438, Wineberg 3237, Vicente Lopez, Provincia de Buenos Aires; Carlos Alberto Blanco, 64 años, casado, empresario, LE: 7.595.957, Wineberg 3237, Vicente Lopez, Provincia de Buenos Aires; Santiago Carlos Blanco, 30 años, soltero, empleado, DNI: 29.040.722, Fray Justo  Sarmiento  2696  Vicente  López,  Provincia de Buenos Aires; Florencia Crosta Blanco, 27 años, divorciada,  empleada, DNI: 30.925.287, Avenida Santa Fe 2179, 2° piso, departamento  âAâ,  Ciudad  Autónoma  de  Buenos  Aires; todos  argentinos. Denominación: âClínica Las Araucarias S.A.â.  Duración:  99  años.  Objeto: La explotación  comercial y administración  de establecimientos asistenciales, hospitales, clínicas, sanatorios y todo tipo de centros de salud, la creación, contratación,  organización, promoción y explotación de toda clase de sistemas de cobertura médica y social, individual o colectiva, a través de sistemas de pago directo, prepago,  abonos,  reintegros o cualquier otro que se estableciere. Organización y explotación de sistemas destinados a la cobertura de emergencias personales para el traslado movilidad de pacientes de obras sociales o particulares, el que será prestado por medio de ambulancias terrestres, aéreas y/o fluviales o cualquier otro tipo de unidades móviles. Todas las actividades que en virtud de la materia lo requieran, serán ejercidas por profesionales con título habilitante. Capital: $ 24.000. Administración: mínimo 1 máximo 10. Representación: presidente o vicepresidente.  Fiscalización: sin síndicos. Cierre de Ejercicio: 30/06. Directorio: Presidente: Fernando Martin Bernat, Vicepresidente: Matias Gonzalo Felix Oteo, Director  Titular: Carolina Schiappacasse y Santiago Carlos Blanco, Director Suplente: Florencia Crosta Blanco. Sede Social: Deheza 2544, departamento  â2â, Ciudad Autónoma de Buenos Aires.Maximiliano Stegmann, Abogado, T° 68 F° 594, Autorizado en Escritura de Constitución N° 571 del 21/9/11, Escribana Carolina R. Arista Farini, Registro 3 de Vicente Lopez."

    assert_equal "30925287", s.personas.detect { |p| p.nombre == "Florencia Crosta Blanco" }.dni
  end
end
