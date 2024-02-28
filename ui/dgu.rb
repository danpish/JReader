## this is my custom "GUI" library
# designed by daniel pishyar Q1 of 2024

require "gosu"
require "open-uri"
require "fileutils"

$known_filetypes = ["png", "jpg", "gif", "jpeg"]

$stroke = false
$stroke_weigh = 5
$stroke_color = Gosu::Color::RED

$active_text = nil

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

  def visible(set)
    @visible = set
  end

  def visible?
    return @visible
  end

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
    if not @visible
      return 0
    end
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
      for points in 1..@res
        normalize = points.to_f / @res
        normalize *= 2 * Math::PI
        draw_quad(
          center_x + Math.cos(previous_point) * @radious - $stroke_weigh * Math.cos(previous_point) / 2, center_y - Math.sin(previous_point) * @radious + $stroke_weigh * Math.sin(previous_point) / 2, $stroke_color,
          center_x + Math.cos(previous_point) * @radious + $stroke_weigh * Math.cos(previous_point) / 2, center_y - Math.sin(previous_point) * @radious - $stroke_weigh * Math.sin(previous_point) / 2, $stroke_color,
          center_x + Math.cos(normalize) * @radious + $stroke_weigh * Math.cos(normalize) / 2, center_y - Math.sin(normalize) * @radious - $stroke_weigh * Math.sin(normalize) / 2, $stroke_color,
          center_x + Math.cos(normalize) * @radious - $stroke_weigh * Math.cos(normalize) / 2, center_y - Math.sin(normalize) * @radious + $stroke_weigh * Math.sin(normalize) / 2, $stroke_color
        )
        previous_point = normalize
      end
    end
  end
end

class Ellipse < Shapes
  def initialize(radious1, radious2, res, color1, color2 = nil)
    @radious1 = radious1
    @radious2 = radious2
    @res = res
    @color1 = color1
    @color2 = color2
  end

  def make(posx, posy)
    if not @visible
      return 0
    end
    previous_point = 0
    center_x = posx + @radious1
    center_y = posy + @radious2
    for each_point in 1..@res
      normalize = each_point.to_f / @res
      normalize *= 2 * Math::PI
      if @color2.nil?
        draw_triangle(
          Math.cos(previous_point) * @radious1 + center_x, Math.sin(previous_point) * @radious2 + center_y, @color1,
          Math.cos(normalize) * @radious1 + center_x, Math.sin(normalize) * @radious2 + center_y, @color1,
          center_x, center_y, @color1
        )
      end
      previous_point = normalize
    end

    if $stroke
      for points in 1..@res
        normalize = points.to_f / @res
        normalize *= 2 * Math::PI
        draw_quad(
          center_x + Math.cos(previous_point) * @radious1 - $stroke_weigh * Math.cos(previous_point) / 2, center_y - Math.sin(previous_point) * @radious2 + $stroke_weigh * Math.sin(previous_point) / 2, $stroke_color,
          center_x + Math.cos(previous_point) * @radious1 + $stroke_weigh * Math.cos(previous_point) / 2, center_y - Math.sin(previous_point) * @radious2 - $stroke_weigh * Math.sin(previous_point) / 2, $stroke_color,
          center_x + Math.cos(normalize) * @radious1 + $stroke_weigh * Math.cos(normalize) / 2, center_y - Math.sin(normalize) * @radious2 - $stroke_weigh * Math.sin(normalize) / 2, $stroke_color,
          center_x + Math.cos(normalize) * @radious1 - $stroke_weigh * Math.cos(normalize) / 2, center_y - Math.sin(normalize) * @radious2 + $stroke_weigh * Math.sin(normalize) / 2, $stroke_color
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
    @visible = true
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
    for corner in rads
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

  def corner_data?()
    if @rads[0].nil?
      nil
    end
    [@rads[0], @rads[1], @rads[2], @rads[3]]
  end

  def make(posx, posy)
    if not @visible
      return 0
    end
    @round_corners = true
    for corner in @rads
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
        posx + @rads[2], posy + @r_h - @rads[2], @color1,
        posx + @rads[2], posy + @r_h, @color1,
        posx + @r_w - @rads[3], posy + @r_h, @color1,
        posx + @r_w - @rads[3], posy + @r_h - @rads[3], @color1
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
      for points in 1..16
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
        for points in 1..16
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
            center_x + Math.cos(previous_point) * dest_rad - $stroke_weigh * Math.cos(previous_point) / 2, center_y - Math.sin(previous_point) * dest_rad + $stroke_weigh * Math.sin(previous_point) / 2, $stroke_color,
            center_x + Math.cos(previous_point) * dest_rad + $stroke_weigh * Math.cos(previous_point) / 2, center_y - Math.sin(previous_point) * dest_rad - $stroke_weigh * Math.sin(previous_point) / 2, $stroke_color,
            center_x + Math.cos(normalize) * dest_rad + $stroke_weigh * Math.cos(normalize) / 2, center_y - Math.sin(normalize) * dest_rad - $stroke_weigh * Math.sin(normalize) / 2, $stroke_color,
            center_x + Math.cos(normalize) * dest_rad - $stroke_weigh * Math.cos(normalize) / 2, center_y - Math.sin(normalize) * dest_rad + $stroke_weigh * Math.sin(normalize) / 2, $stroke_color
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
          @r_w + $stroke_weigh,
          $stroke_weigh,
          $stroke_color
        )
        draw_rect(
          posx + @r_w - $stroke_weigh / 2,
          posy - $stroke_weigh / 2,
          $stroke_weigh,
          @r_h + $stroke_weigh,
          $stroke_color
        )
      end
    end
  end
end

class Button < Rectangle

  # planned to add
  # is_bold
  def initialize(r_w, r_h, text, color1, text_size = 5, margin = 5, text_color = Gosu::Color::BLACK, color2 = nil, rads = Array.new(4))
    @r_w = r_w
    @r_h = r_h
    @text = text
    @text_image = Gosu::Image.from_text(text, text_size, width: r_w - margin)
    @text_color = text_color
    @color1 = color1
    @color2 = color2
    @rads = rads
    @text_size = text_size
    @margin = margin
    @posx = nil
    @posy = nil
    @old_color = color1
    @visible = true
  end

  def job
  end

  def add(posx, posy)
    if not @visible
      return 0
    end
    @posx = posx
    @posy = posy
    make(@posx, @posy)
    @text_image.draw(posx + @margin, posy + @margin, 0, 1, 1, @text_color)
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

    @RGB = [@color1.red(), @color1.green(), @color1.blue()]
    @DEST_RGB = Array.new(3)
    for color in 0..2
      @DEST_RGB[color] = @RGB[color] + 100
      if @DEST_RGB[color] > 255
        @DEST_RGB[color] = 255
      end
    end

    @color1 = Gosu::Color::rgb(@DEST_RGB[0], @DEST_RGB[1], @DEST_RGB[2])

    if button_down?(256)
      for color in 0..2
        @DEST_RGB[color] = @RGB[color] - 100
        if @DEST_RGB[color] < 0
          @DEST_RGB[color] = 0
        end
      end
      @color1 = Gosu::Color::rgb(@DEST_RGB[0], @DEST_RGB[1], @DEST_RGB[2])
    end
  end

  def clicked(mouse_x, mouse_y)
    if not @visible
      return 0
    end
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

class Slider < Rectangle
  def initialize(r_h, min, max)
    @r_h = r_h
    @min = min
    @max = max
    @value = min
    @pos_x = nil
    @pos_y = nil
    @rect_color = Gosu::Color::GRAY
    @persentage = 0.0
    @is_mouse_on = false
    @mouse_on_scroll = false
    @visible = true
  end

  def make(posx, posy)
    if not @visible
      return 0
    end
    @pos_x = posx
    @pos_y = posy
    draw_rect(
      posx, posy, 20, @r_h, Gosu::Color::WHITE
    )
    draw_triangle(
      posx + 10, posy + 5, Gosu::Color::GRAY,
      posx + 5, posy + 15, Gosu::Color::GRAY,
      posx + 15, posy + 15, Gosu::Color::GRAY
    )
    draw_triangle(
      posx + 10, posy + @r_h - 5, Gosu::Color::GRAY,
      posx + 5, posy + @r_h - 15, Gosu::Color::GRAY,
      posx + 15, posy + @r_h - 15, Gosu::Color::GRAY
    )
    draw_rect(
      posx + 1, @value + posy + 20,
      18, 18,
      @rect_color
    )
  end

  def change(mouse_x, mouse_y, mouse_down)
    @rect_color = Gosu::Color::GRAY
    if not @mouse_on_scroll
      if @pos_x.nil? or @pos_y.nil?
        return 0
      end
      if not mouse_x > @pos_x + 1 or not mouse_x < @pos_x + 18
        return 0
      end
      if not mouse_y > @pos_y + 20 + @value or not mouse_y < @pos_y + 38 + @value
        return 0
      end
    end

    @mouse_on_scroll = true

    if not mouse_down
      @mouse_on_scroll = false
      return 0
    end
    if not @mouse_on_scroll
      return 0
    end

    @rect_color = Gosu::Color::RED
    @value = mouse_y - @pos_y - 25
    if @value < 0
      @value = 0
    end
    if @value > @r_h - 60
      @value = @r_h - 60
    end
    @persentage = @value / (@r_h - 60) * (@max - @min) + @min
    on_change(@persentage)
  end

  def on_change(pers)
    puts pers
  end

  def value
    return @value
  end
end

class Image < Gosu::Image
  def download_image(url, name)
    filetype = ""
    succes = false
    begin
      d_file = URI.parse(url).open().read

      for char in 1..3
        filetype = url[-char] + filetype
      end
      for formats in $known_filetypes
        if filetype == formats
          succes = true
        end
      end
      if not succes
        filetype = ""
        for char in 1..4
          filetype = url[-char] + filetype
        end
        puts filetype
        for formats in $known_filetypes
          if filetype == formats
            succes = true
          end
        end
      end
      @downloaded_image = 2
      if succes
        @downloaded_image = 1
        File.open("temp/#{name}.#{filetype}", "wb").write(d_file)
        @filetype = filetype
      end
      d_file = nil
    rescue
      puts "IMAGE LOADING CODE BLOCK FAILED"
      succes = false
    end
  end

  def reload
    begin
      @got_image = nil
      @got_image = Gosu::Image.new("temp/#{@image_name}.#{@filetype}")
    rescue
      puts "ERROR DGU #{__LINE__} image reload failed"
    end
  end

  def initialize(image_link, image_name, is_online = true)
    @image_name = image_name
    if not File.directory?("temp")
      puts "ERROR #{__LINE__} temp folder doesn't exist"
      return 0
    end
    @downloaded_image = 0 # 0 no, 1 yes, 2 failed
    @loading_image = Gosu::Image.from_text("loading...", 20)
    @failed_image = Gosu::Image.from_text("failed :C", 20)
    @did_reload = false
    if is_online
      Thread.new { download_image(image_link, image_name) }
    end
    @visible = true
  end

  def width
    if @got_image.class == Gosu::Image
      @got_image.width
    else
      0
    end
  end

  def height
    if @got_image.class == Gosu::Image
      @got_image.height
    else
      0
    end
  end

  def make(posx, posy, width = nil, height = nil, got_res = false)
    if not @visible
      return 0
    end
    if @downloaded_image == 1
      if not @did_reload
        @did_reload = true
        reload
      end
      scalex, scaley = 1, 1
      if not @got_image.nil?
        if got_res
          if not width.nil?
            if not width.class == Float
              width = width.to_f
            end
            scalex = width / @got_image.width
          end
          if not height.nil?
            if not height.class == Float
              height = height.to_f
            end
            scaley = height / @got_image.height
          end
        else
          scalex, scaley = width, height
        end
        @got_image.draw(posx, posy, 0, scalex, scaley)
      end
    elsif @downloaded_image == 0
      @loading_image.draw(posx, posy)
    else
      @failed_image.draw(posx, posy)
    end
  end

  def got_image
    @got_image
  end
end

class TextIn < Gosu::TextInput
  def initialize(r_w, r_h, def_text, text_size, max_letters = nil, padding = 5, back_color = Gosu::Color::GRAY, text_color = Gosu::Color::WHITE)
    super()
    self.text = def_text
    @text_size = text_size
    @padding = padding
    @back_color = back_color
    @max_letters = max_letters
    @visible = true
    if @max_letter.nil?
      @max_letters = r_w / @text_size
    end
    @r_w = r_w
    @r_h = r_h
    @shape = Rectangle.new(@r_w, @r_h, @back_color)
  end

  def visible(set)
    @visible = set
  end

  def corner_data(rads)
    @shape.corner_data(rads)
  end

  def active_check(win)
    @back_color = Gosu::Color::GRAY
    if win.text_input == self
      @back_color = Gosu::Color::rgb(200, 200, 200)
    end
    cornet_data = @shape.corner_data?
    @shape = Rectangle.new(@r_w, @r_h, @back_color)
    if not cornet_data.nil?
      @shape.corner_data(cornet_data)
    end
  end

  def make(window, posx, posy)
    if not @visible
      return 0
    end
    @posx = posx
    @posy = posy
    @shape.make(posx, posy)
    Gosu::Image.from_text(self.text, @text_size, width: @text_size * @max_letters - @padding * 2).draw(posx + @padding, posy + @padding)
    active_check(window)
  end

  def get_width
    @text_size * @max_letters
  end

  def get_height
    @text_size
  end

  def clicked(mouse_x, mouse_y)
    if $active_text == self
      $active_text = nil
    end
    if not @visible
      return 0
    end
    if @posx.nil? or @posy.nil?
      return 0
    end
    if not mouse_x > @posx or not mouse_x < @posx + @r_w
      return 0
    end
    if not mouse_y > @posy or not mouse_y < @posy + @r_h
      return 0
    end
    $active_text = self
  end
end
