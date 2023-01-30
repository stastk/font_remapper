require 'sinatra'
class Remapper < Sinatra::Base
  get '/' do
    sz = -> { rand(1..8) }
    sr = -> { rand(1..22) }
    "Shitty test message: #{sz.call}_#{sr.call}"
  end

  get '/glyphs_list' do
    # TODO Glyphs from ELAJC and from PHYREXIAN must be placed in to DB
    %w(q w e r t y)
  end

  post '/remap' do
    to_be_remapped = params[:t]
  end
end

