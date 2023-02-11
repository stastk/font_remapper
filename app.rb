require 'sinatra'
require 'sinatra-websocket'

ARR_PHIE = %w(0 1 2 3 4 5 6 7 8 9 ¯ - « ⅄ Ⅺ ⸘ ‽ ¿ ? ! * + e b d u i k Q E w h c m n o p C r L t Y l v s y & K O A % N Z H T J a _ I B U F G z V R $ M P f S W D D g / ~ \\ ₀ ₁ ₂ ₃ ₄ ₅ ₆ ₇ ₈ ₉ ⁰ ¹ ² ³ ⁴ ⁵ ⁶ ⁷ ⁸ ⁹ ~ ­ . | ,) << " " << ":"
ARR_WOTC = %w(0 1 2 3 4 5 6 7 8 9 − - « Y X ⸘ ‽ ¿ ? ! * + a b d e f g h i j k l m n o p q r s t u v w x y z ð ø č ķ ŋ θ ţ ť ž ǆ ǥ ǧ ǩ ɒ ə ɢ ɣ ɬ ɮ ɴ ʁ π φ χ ẅ ’ ' š : " / -0 -1 -2 -3 -4 -5 -6 -7 -8 -9 +0 +1 +2 +3 +4 +5 +6 +7 +8 +9 " “ . ^) << " " << "," << ","
ARR_WOTC_GSUB_FROM_START = %w(¿ “ ‽ ⸘ ? ! " ^ «)
ARR_WOTC_GSUB_FROM_END = %w(: - “ « . ^)

class Remapper < Sinatra::Base

  set :server, 'thin'
  set :sockets, []

  before /.*\.css/ do
    content_type 'text/css'
  end

  get '/' do
    if !request.websocket?
      erb :index
    else
      request.websocket do |ws|
        ws.onopen do
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

  get '/page' do

    gibberish_letters = `python3 -c 'import freetype, sys; stdout = open(1, mode="w", encoding="utf8"); face = freetype.Face(sys.argv[1]); stdout.write("".join(sorted([chr(c) for c, g in face.get_chars() if c]) + [""]))' ./public/fonts/Phi_horizontal_gbrsh_2.1.ttf`
    normal_letters = `python3 -c 'import freetype, sys; stdout = open(1, mode="w", encoding="utf8"); face = freetype.Face(sys.argv[1]); stdout.write("".join(sorted([chr(c) for c, g in face.get_chars() if c]) + [""]))' ./public/fonts/Phyrexian-Regular.ttf`

    @gibberish_result = gibberish_letters.gsub(/[           ​‌‍‎‏­]/, "").split("")
    @normal_result = normal_letters.gsub(/[           ​‌‍‎‏­]/, "").split("")

    if !request.websocket?
      erb :page
    else
      request.websocket do |ws|
        ws.onopen do
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

  def string_to_hash(string)
    require 'json'
    JSON.parse string
  end

  def remap(t)
    result = self.string_to_hash(t)
    remapped = ""

    if result["direction"].to_s == "normal"
      arr_from = ARR_WOTC
      arr_to = ARR_PHIE
      direction = "gibberish"
      invert_direction = "normal"
    else
      arr_from = ARR_PHIE
      arr_to = ARR_WOTC
      direction = "normal"
      invert_direction = "gibberish"
    end

    result["text"].chars.each do |char|
      if direction == "normal"
        if ARR_PHIE.include? char
          i = arr_from.find_index(char)
          remapped += i.nil? ? char : arr_to[i]
        end
      elsif direction == "gibberish"
        if ARR_WOTC.include? char
          i = arr_from.find_index(char)
          remapped += i.nil? ? char : arr_to[i]
        end
      end
    end

    space_gsubber = ->(x){x == "^" ? "\\^" : x}

    ARR_WOTC_GSUB_FROM_END.each do |gg|
      remapped.gsub!(/[#{space_gsubber.call(gg)}](\s|[,])/, "#{gg} ")
    end

    ARR_WOTC_GSUB_FROM_START.each do |gg|
      remapped.gsub!(/(\s|[,])[#{space_gsubber.call(gg)}]/, " #{gg}")
    end
    [direction.to_s, invert_direction.to_s, remapped.to_s].to_s
  end
end
