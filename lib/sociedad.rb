# encoding: UTF-8
require_relative "core_ext"
require_relative "palabra"
require_relative "persona"

class Sociedad
  attr_accessor :razon_social
  attr_accessor :tipo_social
  attr_accessor :fecha_aparicion
  attr_accessor :text

  STOPWORDS = %w(de la)
  PREFIXES = %w(Abogado Presidente Escribano)
  MAX_DISTANCE = 5

  def text=(value)
    @text = value.gsub(/ {2,}/, " ")
  end

  def personas
    return @personas if defined?(@personas)

    @personas = []

    names = []

    text.gsub!(/\b(S\.?A\.?|S\.?R\.?L|S\.H\.)\b/, "")

    chunks = text.split(/[;,]|\d+\)| y |(?<!\p{Lu}):|(?<!\p{Lu})\.(?!\d)/)

    chunks.each do |chunk|
      if persona = find_persona(chunk)
        @personas << persona
      else
        augment_persona(@personas.last, chunk) if @personas.last
      end
    end

    @personas.uniq! { |p| p.nombre.simplified }

    @personas
  end

private

  def augment_persona(persona, chunk)
    chunk.scan(/D\.?N\.?I.+?([\d .]+)/) do |m|
      persona.dni = m[0]
    end

    chunk.scan(/C\.?U\.?I\.?T.+?([\d -.]+)/) do |m|
      persona.cuit = m[0]
    end
  end

  def find_persona(chunk)
    words = chunk.split(" ")

    dic = words.map do |w|
      next if STOPWORDS.include?(w.simplified)

      w =~ /^\p{Lu}/ &&
        PALABRAS[w].valid?
    end

    return unless dic.count { |x| x } > 1

    lpos, rpos = dic.index(true), dic.rindex(true)

    name = words[lpos..rpos]

    return if name.any? { |w| w =~ /^\d+$/ }

    name = name.drop_while { |w| PREFIXES.include?(w) }

    return unless PALABRAS[name.first.simplified].nombre?

    if name.size > 2
      return if dic[(lpos + 1)..(rpos - 1)].count { |x| !x } > MAX_DISTANCE
    end

    persona = Persona.new
    persona.nombre = name.join(" ")
    persona
  end
end
