require 'zlib'
require 'chunky_png'

# размер стороны идентикона в пикселях 
Size = 250
# размер сетки
Grid = 5
# размер квадрата в пикселях
DSquare = Size / Grid

class Identicon
  attr_accessor :user_name, :path

  # -- Переменные --
  # user_name - никнейм пользователя
  # (опционально) path - путь сохранения идентикона (по умолчанию - текущая папка с расположением программы)
  def initialize(user_name, path = "C:/Programming/identicon_LT" )
    @user_name = user_name
    @path = path
  end

  # создание и сохранение идентикона
  def generate
    identicon_draw(image_arr(@user_name), @color)
    @image.save(@path+"/identicon_"+@id+".png")
  end

  private
  
  # формирование хэш-кода имени пользователя, вида и цвета идентикона
   # -- Переменные --
   # userhash - хэш-код пользователя
   # rows - построчный вид идентикона
   # @id - код для создания уникального имени файла идентикона
   # @color - цвет идентикона
    def image_arr(username)
      userhash = Zlib::crc32(username.downcase)
      @id = userhash.to_s(16)
      rows = []
      Grid.times do
        rows.push(userhash & 31)
        userhash = (userhash >> Grid)
      end
      @color = color_convert(userhash)
      rows
    end
  
  # формирование кода цвета идентикона по хэш-коду
    def color_convert(value)
      r = value % 4 * 63
      g = value / 4 % 4 * 63
      b = value / 8 % 8 * 31
      ChunkyPNG::Color.rgb(r, g, b)
    end

  # формирование изображения идентикона
   # -- Переменные --
   # rows - построчный вид идентикона (см. image_arr)
   # color - цвет квадрата идентикона (см. image_arr)
    def identicon_draw(rows, color)
      png = ChunkyPNG::Image.new(Size, Size, ChunkyPNG::Color::WHITE)
      rows.each_with_index do |y_item, y_index|
        bit_row(y_item).each_with_index do |x_item, x_index|
          if x_item == 1
            png.rect(x_index * DSquare, y_index * DSquare, (x_index + 1) * DSquare, (y_index + 1) * DSquare, color, color )
          end
        end
      end
      @image = png
    end
  
  # развертка строки идентикона по квадратам
    def bit_row(num)
      bitrow = []
      Grid.times do
        bitrow.push(num % 2)
        num = (num >> 1)
      end
      bitrow
    end
end
