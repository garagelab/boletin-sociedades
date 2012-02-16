# encoding: UTF-8
Encoding.default_internal = Encoding.default_external = Encoding::UTF_8

require 'rubygems'
require 'sinatra'

require_relative '../boletin'

class Boletin < Sinatra::Application

  def bdb
    @BDB = BoletinDB.new(File.dirname(__FILE__) + '/../db')
  end
  set :default_encoding, "utf-8"

#  set :public_folder, File.dirname(__FILE__) + '/static'

  get '/' do
    erb :index
  end

  get '/search' do
    @results = bdb.search(params[:q], limit:50)
    erb :search
  end

  get '/persona/:id' do
    raise "NotImplemented"
  end



end
