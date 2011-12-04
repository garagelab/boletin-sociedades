require './boletin'

use Rack::ShowExceptions
run Boletin.new
