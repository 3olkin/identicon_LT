require 'zlib'
require 'chunky_png'
Size = 250

class Identicon
  attr_accessor :user_name, :path

  def initialize(user_name, path = "C:/Programming/identicon_LT/" )
    @user_name = user_name
    @path = path
  end

  def generate
    identicon_draw(image_arr(@user_name), @color)
    @image.save(@path+"identicon_"+@id+".png")
  end

  private

    def image_arr(username)
      userhash = Zlib::crc32(username.downcase)
      @id = userhash.to_s(16)
      rows = []
      5.times do
        rows.push(userhash & 31)
        userhash = (userhash >> 5)
      end
      @color = color_convert(userhash)
      rows
    end

    def color_convert(value)
      r = value % 4 * 63
      g = value / 4 % 4 * 63
      b = value / 8 % 8 * 31
      ChunkyPNG::Color.rgb(r,g,b)
    end

    def identicon_draw(rows, color)
      png = ChunkyPNG::Image.new(Size, Size, ChunkyPNG::Color::WHITE)
      rows.each_with_index do |y_item, y_index|
        bit_row(y_item).each_with_index do |x_item, x_index|
          if x_item == 1
            png.rect(x_index*50, y_index*50, (x_index+1)*50, (y_index+1)*50, color, color )
          end
        end
      end
      @image = png
    end

    def bit_row(num)
      bitrow = []
      5.times do
        bitrow.push(num % 2)
        num = (num >> 1)
      end
      bitrow
    end

    def save(path)
      @image.save(path)
    end
end
