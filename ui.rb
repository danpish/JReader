require "./ui/dgu"

$cool = Circle.new(20, 25, Gosu::Color::CYAN)
$rect = Rectangle.new(100, 100, Gosu::Color::CYAN)

$rect.corner_data([20,5,10,0])

$rect2 = Rectangle.new(100, 100, Gosu::Color::YELLOW)
$rect2.corner_data([30,30,30,30])

$rects = Array.new()

$rand = Random.new()

for x in 1..50 do
  $rects.push (Rectangle.new(100, 100, Gosu::Color::YELLOW))
  $rects[x - 1].corner_data([$rand.rand(10), $rand.rand(10),$rand.rand(10),$rand.rand(10)])
end


class JReader < Gosu::Window
  def initialize
    super $width, $height
  end

  def draw
    $cool.make(100, 100)
    $rect.make(200,150)
    $rect2.make(300,300)
    #$rects.each { |rect| rect.make($rand.rand(800), $rand.rand(600))}
    puts Gosu.fps
  end
end

JReader.new.show
