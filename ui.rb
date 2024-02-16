require "./ui/dgu"

$cool = Circle.new(20, 25, Gosu::Color::CYAN)
$rect = Rectangle.new(100, 100, Gosu::Color::CYAN)

$rect.corner_data([20,5,10,0])

$rect2 = Rectangle.new(100, 100, Gosu::Color::YELLOW)
$rect2.corner_data([30,30,30,30])

class JReader < Gosu::Window
  def initialize
    super $width, $height
  end

  def draw
    $cool.make(100, 100)
    $rect.make(200,150)
    $rect2.make(300,300)
  end
end

JReader.new.show
