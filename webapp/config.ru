# encoding: UTF-8
Encoding.default_internal = Encoding.default_external = Encoding::UTF_8

require './boletin'

use Rack::ShowExceptions
run Boletin.new
