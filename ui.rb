require "./ui/dgu"

$cool = Circle.new(20, 25, Gosu::Color::CYAN)
$rect = Rectangle.new(100, 100, Gosu::Color::CYAN)

$rect.corner_data([20,5,10,0])

$rect2 = Rectangle.new(100, 100, Gosu::Color::YELLOW)
$rect2.corner_data([30,30,30,30])

$truerect = Rectangle.new(350, 100, Gosu::Color::WHITE)
$truerect.corner_data([40,20,30,10])
$rects = Array.new()

$rand = Random.new()

class JReader < Gosu::Window
  def initialize
    super $width, $height
  end

  def draw
    $cool.make(100, 100)
    $rect.make(200,150)
    $rect2.make(300,300)
    puts Gosu.fps
  end
end

JReader.new.show
