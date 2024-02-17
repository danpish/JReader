require "./ui/dgu"

$cool = Circle.new(20, 25, Gosu::Color::CYAN)
$rect = Rectangle.new(100, 100, Gosu::Color::CYAN)

$rect.corner_data([20,5,10,0])

$rect2 = Rectangle.new(100, 100, Gosu::Color::YELLOW)
$rect2.corner_data([30,30,30,30])


$rect3 = Rectangle.new(120, 120, Gosu::Color::GRAY)
$rect3.corner_data([20,15,20,35])

$rect4 = Rectangle.new(100, 100, Gosu::Color::GREEN)
$rect4.corner_data([10,10,20,20])

$rect5 = Rectangle.new(100, 100, Gosu::Color::BLUE)
$rect5.corner_data([5,10,20,10])
class JReader < Gosu::Window
  def initialize
    super $width, $height
  end

  def draw
    $cool.make(100, 100)
    $rect.make(200,150)
    $rect2.make(300,300)
    stroke(true)
    $rect3.make(400,100)
    stroke_weigh(20)
    stroke_color(Gosu::Color::WHITE)
    $rect4.make(450,250)
    stroke(false)
    pop
    $rect5.make(500,450)
  end
end

JReader.new.show
