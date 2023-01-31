require 'sinatra'
require 'sinatra-websocket'

ARR_PHIE = %w(| e b d u i k Q E w h c m n o p C r L t Y l v s y & K O A % N Z H T J a _ I B U F G z V R $ M P f , S W D | g / ~ . \\ ₀ ₁ ₂ ₃ ₄ ₅ ₆ ₇ ₈ ₉ ⁰ ¹ ² ³ ⁴ ⁵ ⁶ ⁷ ⁸ ⁹)
QRR_wotc = %w(^ a b d e f g h i j k l m n o p q r s t u v w x y z ð ø č ķ ŋ θ ţ ť ž ǆ ǥ ǧ ǩ ɒ ə ɢ ɣ ɬ ɮ ɴ ʁ θ π φ χ ẅ ’ ^ š : " . / -0 -1 -2 -3 -4 -5 -6 -7 -8 -9 +0 +1 +2 +3 +4 +5 +6 +7 +8 +9)

class Remapper < Sinatra::Base
  set :server, 'thin'
  set :sockets, []

  get '/' do
    if !request.websocket?
      erb :index
    else
      request.websocket do |ws|
        ws.onopen do
          #ws.send("All will be one")
          settings.sockets << ws
        end
        ws.onmessage do |msg|
          EM.next_tick { settings.sockets.each{|s| s.send(self.remap(msg)) } }

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

  def remap(t)
    @to_be_remapped = ""
    @arr_phie = ARR_PHIE
    @arr_wotc = QRR_wotc
    t.chars.each do |char|
      i = @arr_phie.find_index(char)
      @to_be_remapped += i.nil? ? char : @arr_wotc[i]
    end

    @to_be_remapped.to_s
    #erb :remapper
  end
end

