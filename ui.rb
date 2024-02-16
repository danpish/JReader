require "./ui/dgu"

$cool = Circle.new(20, 25, Gosu::Color::CYAN)

class JReader < Gosu::Window
  def initialize
    super $width, $height
  end

  def draw
    $cool.make(100, 100)
  end
end

JReader.new.show
