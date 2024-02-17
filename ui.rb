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

class JReader < Gosu::Window
  def initialize
    super $width, $height
    @circle_pos = [100,100]
    @move_x = 2
    @move_y = 2
  end

  def draw
    if @circle_pos[0] + 40 * 2 + 13 >= $width or @circle_pos[0] - 13 <= 0
      if @circle_pos[0] < $width / 2
        @circle_pos[0] = 0 + 13
      else
        @circle_pos[0] = $width - 80 - 13
      end
      @move_x *= -1 
    end
    if @circle_pos[1] + 40 * 2 + 13 >= $height or @circle_pos[1] - 13 <= 0
      if @circle_pos[1] < $height / 2
        @circle_pos[1] = 0 + 13
      else
        @circle_pos[1] = $height - 80 - 13
      end
      @move_y *= -1
    end
    @circle_pos[0] += @move_x
    @circle_pos[1] += @move_y
    stroke(true)
    stroke_weigh(26)
    stroke_color(Gosu::Color::rgb($rand.rand(150) + 100,$rand.rand(150) + 100,$rand.rand(150) + 100))
    $cool.make(@circle_pos[0], @circle_pos[1])
    pop
    stroke(true)
    $rect.make(200,150)
    stroke_color(Gosu::Color::BLUE)
    $rect2.make(300,300)
    pop()
    puts Gosu.fps
  end
end

JReader.new.show
