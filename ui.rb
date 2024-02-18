require "./ui/dgu"

$width = 800
$height = 600

$cool = Circle.new(40, 25, Gosu::Color::CYAN)
$rect = Rectangle.new(100, 100, Gosu::Color::CYAN)

$rect.corner_data([20,5,10,0])

$rect2 = Rectangle.new(100, 100, Gosu::Color::YELLOW)
#$rect2.corner_data([30,30,30,30])

$truerect = Rectangle.new(350, 100, Gosu::Color::WHITE)
$truerect.corner_data([40,20,30,10])
$rects = Array.new()

$rand = Random.new()

$button = Button.new(100,100, "woow cool", Gosu::Color::FUCHSIA, 25, 25)

class JReader < Gosu::Window
  def initialize
    super $width, $height
    @circle_pos = [100,100]
    @move_x = 2
    @move_y = 2
  end

  def draw
    stroke(true)
    stroke_weigh(26)
    $button.add(20,20)
    stroke_color(Gosu::Color::rgb($rand.rand(150) + 100,$rand.rand(150) + 100,$rand.rand(150) + 100))
    $cool.make(@circle_pos[0], @circle_pos[1])
    pop
    stroke(true)
    $rect.make(200,150)
    stroke_color(Gosu::Color::BLUE)
    $rect2.make(300,300)
    pop()
    self.caption = "fps : #{Gosu.fps}"
  end
end

JReader.new.show
