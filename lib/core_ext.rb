# encoding: UTF-8

class String
  def simplified
    downcase.tr("áéíóúñ", "aeioun")
  end
end
