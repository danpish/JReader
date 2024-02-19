## this is my custom "GUI" library
# designed by daniel pishyar Q1 of 2024

require "gosu"

$stroke = false
$stroke_weigh = 5
$stroke_color = Gosu::Color::RED

def stroke(do_QM)
  $stroke = do_QM
end

def pop
  $stroke = false
  $stroke_weigh = 5
  $stroke_color = Gosu::Color::RED
end

def stroke_color(color)
  if color.class == Gosu::Color or color.class == Gosu::ImmutableColor
    $stroke_color = color
    return 1
  else
    puts "ERROR: stroke color provided is not valid. are you sure you are using Gosu::Color? #{color.class}"
    return 44
  end
end

def stroke_weigh(value)
  if value.class == Integer or value.class == Float
    $stroke_weigh = value
    return 1
  else
    puts "ERROR: stoke weigh provided is not valid"
    return 44
  end
end

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
  
  def color(color)
    @color1 = color
  end
  
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
    
    if $stroke
      for points in 1..@res do
          normalize = points.to_f / @res
          normalize *= 2 * Math::PI
          draw_quad(
            center_x + Math.cos(previous_point) * @radious - $stroke_weigh * Math.cos(previous_point) / 2,center_y - Math.sin(previous_point) * @radious + $stroke_weigh * Math.sin(previous_point) / 2,$stroke_color,
            center_x + Math.cos(previous_point) * @radious + $stroke_weigh * Math.cos(previous_point) / 2,center_y - Math.sin(previous_point) * @radious - $stroke_weigh * Math.sin(previous_point) / 2,$stroke_color,
            center_x + Math.cos(normalize) * @radious + $stroke_weigh * Math.cos(normalize) / 2,center_y - Math.sin(normalize) * @radious - $stroke_weigh * Math.sin(normalize) / 2,$stroke_color,
            center_x + Math.cos(normalize) * @radious - $stroke_weigh * Math.cos(normalize) / 2,center_y - Math.sin(normalize) * @radious + $stroke_weigh * Math.sin(normalize) / 2,$stroke_color   
          )
          previous_point = normalize
        end
    end
    
  end
end

class Rectangle < Shapes
  def initialize(r_w, r_h, color1, color2 = nil, rads = Array.new(4))
    @r_w = r_w
    @r_h = r_h
    @color1 = color1
    @color2 = color2
    @rads = rads
    @r_scale = 1
    
    @round_corners = false
  end
  
  def change_scale(scale)
    if scale.class == Integer or scale.class == Float
      @r_scale = scale
      return 1
    else
      puts "ERROR: line #{__LINE__} number provided is not a number"
      return 44
    end
  end
  
  def corner_data(rads)
    #validate
    is_valid = true
    for corner in rads do
      if corner.nil?
        is_valid = false
      end
    end
    if is_valid
      @rads = rads
      @round_corners = true
      return 1
    else
      puts "WARNING: line #{__LINE__} array provided is not valid! \n"
      return 44
    end
  end
  
  def make(posx, posy)
    @round_corners = true
    for corner in @rads do
      if corner.nil?
        @round_corners = false
      end
    end
    if @round_corners
      #draw_rect(
      #  posx,
      #  posy,
      #  @r_w,
      #  @r_h,
      #  Gosu::Color::RED
      #)
      draw_quad(
        posx + @rads[0], posy, @color1,
        posx + @rads[0], posy + @rads[0], @color1,
        posx + @r_w - @rads[1], posy + @rads[1], @color1,
        posx + @r_w - @rads[1], posy, @color1,
      )
      draw_quad(
        posx, posy + @rads[0], @color1,
        posx + @rads[0], posy + @rads[0], @color1,
        posx + @rads[2], posy + @r_h - @rads[2], @color1,
        posx, posy + @r_h - @rads[2], @color1
      )
      draw_quad(
        posx + @rads[2],posy + @r_h - @rads[2], @color1,
        posx + @rads[2],posy + @r_h , @color1,
        posx + @r_w - @rads[3],posy + @r_h , @color1,
        posx + @r_w - @rads[3],posy + @r_h - @rads[3], @color1
      )
      draw_quad(
        posx + @r_w - @rads[1], posy + @rads[1], @color1,
        posx + @r_w, posy + @rads[1], @color1,
        posx + @r_w, posy + @r_h - @rads[3], @color1,
        posx + @r_w - @rads[3], posy + @r_h - @rads[3], @color1
      )
      draw_quad(
        posx + @rads[0], posy + @rads[0], @color1,
        posx + @r_w - @rads[1], posy + @rads[1], @color1,
        posx + @r_w - @rads[3], posy + @r_h - @rads[3], @color1,
        posx + @rads[2], posy + @r_h - @rads[2], @color1
      )
      
      previous_point = 0
      for points in 1..16 do
        normalize = points.to_f / 16
        normalize *= 2 * Math::PI
        dest_rad = 0
        if points.to_f / 4 <= 1.to_f
          center_x = posx + @r_w - @rads[1]
          center_y = posy + @rads[1]
          dest_rad = @rads[1]
        elsif points.to_f / 4 <= 2.to_f
          center_x = posx + @rads[0]
          center_y = posy + @rads[0]
          dest_rad = @rads[0]
        elsif points.to_f / 4 <= 3.to_f
          center_x = posx + @rads[2]
          center_y = posy + @r_h - @rads[2]
          dest_rad = @rads[2]
        else
          center_x = posx + @r_w - @rads[3]
          center_y = posy + @r_h - @rads[3]
          dest_rad = @rads[3]
        end
        if points.to_f / 4 == 1.to_f
          normalize = Math::PI / 2
        end
        if points.to_f / 4 == 2.to_f
          normalize = Math::PI
        end
        if points.to_f / 4 == 3.to_f
          normalize = Math::PI * 3 / 2
        end
        draw_triangle(
          center_x + Math.cos(previous_point) * dest_rad, center_y - Math.sin(previous_point) * dest_rad, @color1,
          center_x + Math.cos(normalize) * dest_rad, center_y - Math.sin(normalize) * dest_rad, @color1,
          center_x, center_y, @color1,
        )
        previous_point = normalize
      end
      
      if $stroke
        draw_rect(
          posx + @rads[0],
          posy - $stroke_weigh / 2,
          @r_w - @rads[0] - @rads[1],
          $stroke_weigh,
          $stroke_color
        )
        draw_rect(
          posx - $stroke_weigh / 2,
          posy + @rads[0],
          $stroke_weigh,
          @r_h - @rads[0] - @rads[2],
          $stroke_color
        )
        draw_rect(
          posx + @rads[2],
          posy + @r_h - $stroke_weigh / 2,
          @r_w - @rads[2] - @rads[3],
          $stroke_weigh,
          $stroke_color
        )
        draw_rect(
          posx + @r_w - $stroke_weigh / 2,
          posy + @rads[1],
          $stroke_weigh,
          @r_h - @rads[1] - @rads[3],
          $stroke_color
        )
        
        previous_point = 0
        for points in 1..16 do
          normalize = points.to_f / 16
          normalize *= 2 * Math::PI
          dest_rad = 0
          if points.to_f / 4 <= 1.to_f
            center_x = posx + @r_w - @rads[1]
            center_y = posy + @rads[1]
            dest_rad = @rads[1]
          elsif points.to_f / 4 <= 2.to_f
            center_x = posx + @rads[0]
            center_y = posy + @rads[0]
            dest_rad = @rads[0]
          elsif points.to_f / 4 <= 3.to_f
            center_x = posx + @rads[2]
            center_y = posy + @r_h - @rads[2]
            dest_rad = @rads[2]
          else
            center_x = posx + @r_w - @rads[3]
            center_y = posy + @r_h - @rads[3]
            dest_rad = @rads[3]
          end
          if points.to_f / 4 == 1.to_f
            normalize = Math::PI / 2
          end
          if points.to_f / 4 == 2.to_f
            normalize = Math::PI
          end
          if points.to_f / 4 == 3.to_f
            normalize = Math::PI * 3 / 2
          end
          draw_quad(
            center_x + Math.cos(previous_point) * dest_rad - $stroke_weigh * Math.cos(previous_point) / 2,center_y - Math.sin(previous_point) * dest_rad + $stroke_weigh * Math.sin(previous_point) / 2,$stroke_color,
            center_x + Math.cos(previous_point) * dest_rad + $stroke_weigh * Math.cos(previous_point) / 2,center_y - Math.sin(previous_point) * dest_rad - $stroke_weigh * Math.sin(previous_point) / 2,$stroke_color,
            center_x + Math.cos(normalize) * dest_rad + $stroke_weigh * Math.cos(normalize) / 2,center_y - Math.sin(normalize) * dest_rad - $stroke_weigh * Math.sin(normalize) / 2,$stroke_color,
            center_x + Math.cos(normalize) * dest_rad - $stroke_weigh * Math.cos(normalize) / 2,center_y - Math.sin(normalize) * dest_rad + $stroke_weigh * Math.sin(normalize) / 2,$stroke_color   
          )
          previous_point = normalize
        end
      end
      
    else
      draw_quad(
        posx, posy, @color1,
        posx + @r_w, posy, @color1,
        posx, posy + @r_h, @color1,
        posx + @r_w, posy + @r_h, @color1
      )
      
      if $stroke
        draw_rect(
          posx - $stroke_weigh / 2,
          posy - $stroke_weigh / 2,
          @r_w + $stroke_weigh,
          $stroke_weigh,
          $stroke_color
        )
        draw_rect(
          posx - $stroke_weigh / 2,
          posy - $stroke_weigh / 2,
          $stroke_weigh,
          @r_h + $stroke_weigh,
          $stroke_color
        )
        draw_rect(
          posx - $stroke_weigh / 2,
          posy + @r_h - $stroke_weigh / 2,
          @r_w + $stroke_weigh ,
          $stroke_weigh,
          $stroke_color
        )
        draw_rect(
          posx + @r_w - $stroke_weigh / 2,
          posy - $stroke_weigh / 2 ,
          $stroke_weigh,
          @r_h + $stroke_weigh ,
          $stroke_color
        )
      end
    end
  end
end

class Button < Rectangle
  
  # planned to add
  # is_bold
  def initialize(r_w, r_h, text, color1, text_size = 5, margin = 5,text_color = Gosu::Color::BLACK, color2 = nil, rads = Array.new(4))
    @r_w = r_w
    @r_h = r_h
    @text = text
    @text_color = text_color
    @color1 = color1
    @color2 = color2
    @rads = rads
    @text_size = text_size
    @margin = margin
    @posx = nil
    @posy = nil
    @old_color = color1
  end
  
  def job
  end
  
  def add(posx, posy)
    @posx = posx
    @posy = posy
    make(@posx, @posy)
    Gosu::Image.from_text(@text, @text_size, width:@r_w - @margin).draw(posx + @margin, posy + @margin, 0, 1,1,@text_color)
  end

  def update(mouse_x, mouse_y)
    @color1 = @old_color
    if @posx.nil? or @posy.nil?
      return 0
    end
    if not mouse_x > @posx or not mouse_x < @posx + @r_w
      return 0
    end
    if not mouse_y > @posy or not mouse_y < @posy + @r_h
      return 0
    end
    
    @RGB = [@color1.red(),@color1.green(),@color1.blue()]
    @DEST_RGB = Array.new(3)
    for color in 0..2 do
      @DEST_RGB[color] = @RGB[color] + 100
      if @DEST_RGB[color] > 255
        @DEST_RGB[color] = 255
      end
    end
    
    @color1 = Gosu::Color::rgb(@DEST_RGB[0],@DEST_RGB[1],@DEST_RGB[2])
    
    if button_down?(256)
      
      for color in 0..2 do
        @DEST_RGB[color] = @RGB[color] - 100
        if @DEST_RGB[color] < 0
          @DEST_RGB[color] = 0
        end
      end
      @color1=Gosu::Color::rgb(@DEST_RGB[0],@DEST_RGB[1],@DEST_RGB[2])
    end
  end
  
  def clicked(mouse_x, mouse_y)
    if @posx.nil? or @posy.nil?
      return 0
    end
    if not mouse_x > @posx or not mouse_x < @posx + @r_w
      return 0
    end
    if not mouse_y > @posy or not mouse_y < @posy + @r_h
      return 0
    end
    job
  end
  
end
