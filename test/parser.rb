# encoding: UTF-8

require_relative "../lib/parser"

require "test/unit"
require "stringio"

class ParserTest < Test::Unit::TestCase
  def test_parser
    io = StringIO.new(<<-EOS)
Lorem ipsum dolor
sit amet

TERMINAL SAN RAFAEL

SOCIEDAD ANONIMA

Se  aclara  aviso  del  13/10/11  factura N° 59-129465: San Martín 66, 5° piso, oficina 98 es la sede social de Nldgroup S.A. Autorizado en escritura N° 188 del 26/9/11.
Abogado Maximiliano Stegmann e. 26/10/2011 N° 137638/11 v. 26/10/2011



TRANSPGRAF

SOCIEDAD ANONIMA

Rectificación  de edicto  Nro. 120502/11  del
22/9/2011,  en el título y en el punto  2)  debe decir: âDistribuidora Pastoral Americana S.A.â.Alberto  I. Guillén, DNI 31.547.832, autorizado por  Escr. del 5/9/2011,  F° 390 Reg. 1956 de CABA.

Certificación emitida por: María Celeste Parodi. N° Registro: 1956. N° Matrícula: 3028. Fecha: 7/10/2011. N° Acta: 93. Libro N°: 55.
e. 26/10/2011 N° 137902/11 v. 26/10/2011



TRUEIMAGE

SOCIEDAD ANONIMA

Escrituras públicas  números 377 y 410 del Registro Notarial 516. Socios: Claudio Fabián Zanetti, argentino, casado, ingeniero en electrónica,  31/07/1963,  DNI 16.558.685,  Horacio Quiroga 4901, Ituzaingo, Buenos Aires y Elena Concepción Pérez, argentina, casada, comerciante, 30/11/1938, LC 3.859.850, Av. Juan Bautista Alberdi 573, piso 2, âDâ, CABA. Duración: Noventa y nueve años. Objeto: Provisión de servicios y tecnología relacionados con la actividad eléctrica y electrónica; fabricación de productos y equipos; presentación en licitaciones públicas y privadas y ejercer representaciones y mandatos de firmas y/o personas extranjeras o del país; importaciones  y exportaciones en general. Capital: $ 12.000. Dirección y Administración: Directorio, integrado por un mínimo de uno y un máximo de cinco, con mandato por tres  años.  Representación Legal: Presidente. Directorio: Presidente: Claudio. Fabián Zanetti. Director Suplente: Elena Concepción Pérez. Fiscalización: Se prescinde. Cierre del Ejercicio: 30/09 de cada año. Sede Social y Domicilio especial: Avenida Juan Bautista Alberdi número
573, piso  segundo,  departamento  âDâ, de  la Ciudad Autónoma de Buenos Aires. Autorizado por Escrituras públicas Nros. 377 y 410 del
27/09/2011  y 19/10/2011,  ambas del Registro Notarial  516  a Cargo  del  Escribano  Gustavo Badino.
Escribano Gustavo Badino e. 26/10/2011 N° 137803/11 v. 26/10/2011

    EOS

    sociedades = []

    Parser.parse(io) { |s| sociedades << s }

    assert_equal 3, sociedades.size

    assert_equal "TERMINAL SAN RAFAEL", sociedades[0].razon_social
    assert_equal "TRANSPGRAF", sociedades[1].razon_social
    assert_equal "TRUEIMAGE", sociedades[2].razon_social
  end
end
