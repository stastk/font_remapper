require 'sinatra'
require 'sinatra-websocket'

class Remapper < Sinatra::Base
  set :server, 'thin'
  set :sockets, []

  get '/' do
    if !request.websocket?
      erb :index
    else
      request.websocket do |ws|
        ws.onopen do
          ws.send("All will be one")
          settings.sockets << ws
        end
        ws.onmessage do |msg|
          EM.next_tick { settings.sockets.each{|s| s.send(msg) } }
        end
        ws.onclose do
          warn("websocket closed")
          settings.sockets.delete(ws)
        end
      end
    end
  end

  get '/glyphs_list' do
    # TODO Glyphs from ELAJC and from PHYREXIAN must be placed in to DB
    %w(q w e r t y)
  end

  post '/remap' do
    to_be_remapped = params[:t]
  end
end

