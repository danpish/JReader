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

$button_move_pos = [400,400]

$rand = Random.new()

class Buttonf < Button
  
  def job
    puts "woow ive been pressed"
  end
  
end

class Imove < Button
  
  def job
    $button_move_pos[0] = 500
    $button_move_pos[1] = 500
  end
  
end

$button = Buttonf.new(100,100, "woow cool", Gosu::Color::FUCHSIA, 25, 25)
$button_move = Imove.new(150,100, "I Move", Gosu::Color::FUCHSIA, 25,10)
$button.corner_data([40,20,30,10])
$button_move.corner_data([10,10,10,10])

class JReader < Gosu::Window
  def initialize
    super $width, $height
    @circle_pos = [100,100]
    @move_x = 2
    @move_y = 2
  end

  def update
    $button.update(mouse_x, mouse_y)
    $button_move.update(mouse_x, mouse_y)
  end

  def draw
    stroke(true)
    stroke_weigh(26)
    $button.add(20,20)
    stroke_color(Gosu::Color::rgb($rand.rand(150) + 100,$rand.rand(150) + 100,$rand.rand(150) + 100))
    $cool.make(@circle_pos[0], @circle_pos[1])
    pop
    stroke(true)
    $button_move.add($button_move_pos[0],$button_move_pos[1])
    $rect.make(200,150)
    stroke_color(Gosu::Color::BLUE)
    $rect2.make(300,300)
    pop
    self.caption = "fps : #{Gosu.fps}"
    $button_move_pos[0] += 0.5
    $button_move_pos[1] += 0.5
  end
  
  def button_up(key)
    if key == 256
      $button.clicked(mouse_x, mouse_y)
    $button_move.clicked(mouse_x, mouse_y)
    end
  end
  
  
end

JReader.new.show
