require "gosu"

$width = 800
$height = 600

class Shapes < Gosu::Window
  ##
  # none
  # vertical
  # horizontal
  # forward_slash
  # back_slash
  ##
  @shader_info = "none" # not used yet
  @visible = true
end

class Circle < Shapes
  def initialize(radious, res, color1, color2 = nil)
    @radious = radious
    @res = res
    @color1 = color1
    @color2 = color2
  end

  def make(posx, posy)
    previous_point = 0
    center_x = posx + @radious
    center_y = posy + @radious
    for each_point in 1..@res
      normalize = each_point.to_f / @res
      normalize *= 2 * Math::PI
      if @color2.nil?
        draw_triangle(
          Math.cos(previous_point) * @radious + center_x, Math.sin(previous_point) * @radious + center_y, @color1,
          Math.cos(normalize) * @radious + center_x, Math.sin(normalize) * @radious + center_y, @color1,
          center_x, center_y, @color1
        )
      end
      previous_point = normalize
    end
  end
end

class Rectangle < Shapes
  def initialize(r_w, r_h, r_scale = 1, color1, color2 = nil, rads = Array.new(4))
    @r_w = r_w
    @r_h = r_h
    @color1 = color1
    @color2 = color2
    @rads = rads
    @r_scale = r_scale
  end
  
  def make(posx, posy)
    draw_quad(
      posx, posy, @color1,
      posx + @r_w, posy, @color1,
      posx, posy + @r_h, @color1,
      posx + @r_w, posy + @r_h, @color1
    )
  end
end