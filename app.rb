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
  end

  get '/remap' do
    @original = params[:t]
    @to_be_remapped = ""
    @arr_phie = %w(e b d u i k Q E w h c m n o p C r L t Y l v s y & K O A % N Z H T J a I B U F G z V R $ M P f S W D | g / ~ .)
    @arr_phie << "\\"
    @arr_phie << ","

    @arr_wotc = %w(a b d e f g h i j k l m n o p q r s t u v w x y z ð ø č ķ ŋ θ ţ ť ž ǆ ǥ ǧ ǩ ɒ ə ɢ ɣ ɬ ɮ ɴ ʁ θ π φ χ ẅ ’ ^ š : " . /)
    @arr_wotc << " "

    @original.chars.each do |char|
      i = @arr_phie.find_index(char)
      @to_be_remapped += @arr_wotc[i]
    end

    erb :remapper
  end
end

