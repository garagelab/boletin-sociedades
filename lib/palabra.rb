# encoding: UTF-8

require "raspell"
require "redis"

class Palabra
  attr :nombre
  attr :apellido

  MAGIC_NUMBER = 10

  def initialize(palabra, nombre, apellido)
    @palabra = palabra
    @nombre = nombre || 0
    @apellido = apellido || 0
  end

  def valid?
    nombre? || apellido?
  end

  def speller
    @speller ||= begin
      speller = Aspell.new("es")
      speller.set_option("ignore-case", "true")
    end
  end

  def nombre?
    @nombre > MAGIC_NUMBER
  end

  def apellido?
    @apellido > MAGIC_NUMBER || (@apellido > 0 && !speller.check(@palabra))
  end
end

PALABRAS = Hash.new do |h, k|
  names = Redis.current.zscore("names", k.simplified)
  last_names = Redis.current.zscore("last_names", k.simplified)

  h[k] = Palabra.new(k, names.to_i, last_names.to_i)
end
