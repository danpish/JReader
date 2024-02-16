require "gosu"

$width = 800
$height = 600

class App < Gosu::Window
  def initialize
    super $width, $height
  end

  def draw_window
  end

  def draw
    draw_window
  end

  def draw_circle(radious, posx, posy, res, color = Gosu::Color::CYAN)
    previous_point = 0
    center_x = posx + radious
    center_y = posy + radious
    for each_point in 1..res
      normalize = each_point.to_f / res
      normalize *= 2 * Math::PI
      draw_triangle(
        Math.cos(previous_point) * radious + center_x, Math.sin(previous_point) * radious + center_y, color,
        Math.cos(normalize) * radious + center_x, Math.sin(normalize) * radious + center_y, color,
        center_x, center_y, color
      )
      previous_point = normalize
    end
  end
end
