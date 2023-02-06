require 'sinatra'
require 'sinatra-websocket'

ARR_PHIE = %w(¯ « ⅄ Ⅺ − ⸘ ‽ ¿ ? ! * + e b d u i k Q E w h c m n o p C r L t Y l v s y & K O A % N Z H T J a _ I B U F G z V R $ M P f S W D D g / ~ \\ ₀ ₁ ₂ ₃ ₄ ₅ ₆ ₇ ₈ ₉ ⁰ ¹ ² ³ ⁴ ⁵ ⁶ ⁷ ⁸ ⁹ ~ ­ : . | ,) << " "
ARR_WOTC = %w(- « Y X − ⸘ ‽ ¿ ? ! * + a b d e f g h i j k l m n o p q r s t u v w x y z ð ø č ķ ŋ θ ţ ť ž ǆ ǥ ǧ ǩ ɒ ə ɢ ɣ ɬ ɮ ɴ ʁ π φ χ ẅ ’ ' š : " / -0 -1 -2 -3 -4 -5 -6 -7 -8 -9 +0 +1 +2 +3 +4 +5 +6 +7 +8 +9 " “ , . ^) << " " << ","
ARR_WOTC_GSUB_FROM_START = %w(¿ “ ‽ ⸘ ? ! " ^ «)
ARR_WOTC_GSUB_FROM_END = %w(: - “ « . ^)

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

  get '/remap_do' do
    self.remap(params[:t])
  end

  def remap(t)
    remapped = ""
    arr_phie = ARR_PHIE
    arr_wotc = ARR_WOTC

    t.chars.each do |char|
      i = arr_phie.find_index(char)
      remapped += i.nil? ? char : arr_wotc[i]
    end
    space_gsubber = ->(x){x == "^" ? "\\^" : x}
    ARR_WOTC_GSUB_FROM_END.each do |gg|
      remapped.gsub!(/[#{space_gsubber.call(gg)}](\s|[,])/, "#{gg} ")
    end

    ARR_WOTC_GSUB_FROM_START.each do |gg|
      remapped.gsub!(/(\s|[,])[#{space_gsubber.call(gg)}]/, " #{gg}")
    end

    "#{remapped.to_s}<br><span style='font-family:\"Phi_horizontal_gbrsh_2.1\"'>#{t.to_s}</span>"
    #erb :remapper
  end
end

