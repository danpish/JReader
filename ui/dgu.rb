## this is my custom "GUI" library
# designed by daniel pishyar Q1 of 2024

require "gosu"
require "open-uri"
require "fileutils"

$known_filetypes = ["png", "jpg", "gif", "jpeg"]

#settings used by objects

$stroke = false
$stroke_weigh = 5
$stroke_color = Gosu::Color::RED

#active textinput (is used by main application)

$active_text = nil

#array of graphical settings to be used by shapes (unused for now)

$graphical_settings = Array.new(0)

def push
  $graphical_settings.push([$stroke, $stroke_weigh, $stroke_color])
end

=begin
def pop
  $graphical_settings.pop
  last_settings = $graphical_settings.last
  $stroke = last_settings[0]
  $stroke_weigh = last_settings[1]
  $stroke_color = last_settings[2]
end
=end

def pop
  $stroke = false
  $stroke_weigh = 5
  $stroke_color = Gosu::Color::RED
end

def stroke(do_QM)
  $stroke = do_QM
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

# Shapes is foundation of all shapes in dgu

# visible gets a boolean that changes the shapes visibility
# this function is usable acros all of the shapes with images and textin being exceptions

# visible? returns shapes visible state

# color gets a gosu::color and changes the main color of shapes(not used in textin and images)

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

# Circle is a shape that can be defined and be used multiple times
# the initialization requires 3 variuables radious, circle_resolution, main_color
# it also accepts additional argument secondary_color for gradiant however its not implemented yet

# drawing function for circle is make and it take 2 arguments position_x, position_y

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
    # set the drawing position anchor to top left (move the circle to bottom right)
    center_x = posx + @radious
    center_y = posy + @radious
    # place points arount the curcle from 0(begining) to 1(complete circle)
    for each_point in 1..@res
      #turn position of our point into radians (from 0 to 2PI)
      normalize = each_point.to_f / @res
      normalize *= 2 * Math::PI

      if @color2.nil?
        # connect current and previous points and draw rectangle with them and the center
        draw_triangle(
          Math.cos(previous_point) * @radious + center_x, Math.sin(previous_point) * @radious + center_y, @color1,
          Math.cos(normalize) * @radious + center_x, Math.sin(normalize) * @radious + center_y, @color1,
          center_x, center_y, @color1
        )
      end
      #set the previous point to current radians and move to the next step
      previous_point = normalize
    end

    if $stroke
      #simmilar to circle draw function
      for points in 1..@res
        normalize = points.to_f / @res
        normalize *= 2 * Math::PI
        # draw a triangle between current and previous points
        # that ranges $stroke_weigh amount closer and away from the center of the circle
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

# Ellipse is a shape that can be defined and be used multiple times
# the initialization requires 4 variuables width, height, ellipse_resolution, main_color
# it also accepts additional argument secondary_color for gradiant however its not implemented yet

# drawing function for ellipse is make and it take 2 arguments position_x, position_y

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
        # drawing function is simmilar to circle however
        # ellipse points position x multiplier and position y multiplier are set and used seperately
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
          # drawing function is simmilar to circles stroke however
          # ellipse points position x multiplier and position y multiplier are set and used seperately
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

# Rectangle is a shape that can be defined and be used multiple times
# the initialization requires 3 variuables width, height, main_color
# it also accepts additional argument secondary_color for gradiant however its not implemented yet

# another optional argurment is an array of 4 radious values that if set, draws a rectangle with rounded corners with 4 given radious
# setting corner radious this way is not recommended please use corner_data function

# drawing function for ellipse is make and it take 2 arguments position_x, position_y

# corner function gets an array of 4 numbers(radious) for corners of the rectangle.
# if not set, rectangle will be drawn normaly without rounded edges
# the function also have array error check if array provided does not have correct values or length

# corner_data? returns an array of 4 currently set corner radious
# if the rectangle does not have corner data the function returns an empty array(nil,nil,nil,nil)

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
      puts "ERROR: line #{__LINE__} number provided is not a valid data type"
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
      return nil
    end
    return [@rads[0], @rads[1], @rads[2], @rads[3]]
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
      # draw 4 faces of rectangle first
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
      #fill the center
      draw_quad(
        posx + @rads[0], posy + @rads[0], @color1,
        posx + @r_w - @rads[1], posy + @rads[1], @color1,
        posx + @r_w - @rads[3], posy + @r_h - @rads[3], @color1,
        posx + @rads[2], posy + @r_h - @rads[2], @color1
      )

      # draw circle around the corners
      # corner circle resolution is hard coded to 16
      previous_point = 0
      for points in 1..16
        normalize = points.to_f / 16
        normalize *= 2 * Math::PI

        # move circle to different corners of the triangle
        # with different radious
        dest_rad = 0
        #first quater of circle
        #placed at top left
        if points.to_f / 4 <= 1.to_f
          center_x = posx + @r_w - @rads[1]
          center_y = posy + @rads[1]
          dest_rad = @rads[1]
          #second quater of circle
          #placed at top right
        elsif points.to_f / 4 <= 2.to_f
          center_x = posx + @rads[0]
          center_y = posy + @rads[0]
          dest_rad = @rads[0]
          #third quater of circle
          #placed at bottom right
        elsif points.to_f / 4 <= 3.to_f
          center_x = posx + @rads[2]
          center_y = posy + @r_h - @rads[2]
          dest_rad = @rads[2]
          #last quater of circle
          #placed at buttom left
        else
          center_x = posx + @r_w - @rads[3]
          center_y = posy + @r_h - @rads[3]
          dest_rad = @rads[3]
        end
        # set points to circles each milestone points
        # prevents circle from drawing over or start away from each triangle corner
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
        # draw 4 lines at each face of triangle
        # length of each line is reduced by both corner radious at both side of the line
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

        #simmilar to corner and circle stroke
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
      # no corners provided and draw a simple rectangle
      draw_quad(
        posx, posy, @color1,
        posx + @r_w, posy, @color1,
        posx, posy + @r_h, @color1,
        posx + @r_w, posy + @r_h, @color1
      )

      # draw 4 lines covering full length of the faces
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

# Button is a shape that unlike other shapes can be assined to do a function once used
# the initialization requires 4 variuables width, height, label, main_color

# other optional arguments include textsize(in pixels), margin(distance of text from top left of the shape in pixels)
# text color, color2(for gradiant support correnly unsupported)

# click function of button is defined by defining of a new button class and modifying the job function

# unlike other shapes, Button is drawn with add function that takes position X and Y with anchor of top left

# for effects to take place add the buttons update function to the applications update function and add clicked function to the button_down function
# both take 2 variuables of the current mouse position x and y

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

  # because this class is continewation of rectangle function, make function cannot be called directly

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
    # prevents function from executing if the button is not drawn
    if @posx.nil? or @posy.nil?
      return 0
    end
    # check if mouse cursor is on the button
    if not mouse_x > @posx or not mouse_x < @posx + @r_w
      return 0
    end
    if not mouse_y > @posy or not mouse_y < @posy + @r_h
      return 0
    end

    # seperate the given color to an array of 3.
    # this function makes color modification possible
    @RGB = [@color1.red(), @color1.green(), @color1.blue()]
    @DEST_RGB = Array.new(3)

    # lighten the color
    for color in 0..2
      @DEST_RGB[color] = @RGB[color] + 100
      if @DEST_RGB[color] > 255
        @DEST_RGB[color] = 255
      end
    end

    @color1 = Gosu::Color::rgb(@DEST_RGB[0], @DEST_RGB[1], @DEST_RGB[2])

    # darken the color if mouse left click is active
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

# Slider is a shape that unlike other shapes can be assined to do a function once used
# the initialization requires 3 variuables height, minimum_value, maximum_value

# drawing function for Slider is make and it take 2 arguments position_x, position_y
# width of slider is hardcoded to be 20 pixels

# for slider to function the change function must be added to applications update function
# it takes 3 arguments position of mouse x and y and status of mouse left click (with button_down?)

# on change slider calls on_change function which can be overwritten by defining a custom class

# value function returns the sliders current value ranging from minimum to maximum

# value of slider increases with sliders position from top to bottom

class Slider < Shapes
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
    #tall white rectangle
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
    # the main slider
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
    # normalize the value from min to max
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

# Image is a continewation of gosus image function with the ability to load images from the web
# the initialization requires 2 variables, image_url and a file name(without extention)

# one other optional variuable is a boolean that endicates that should image be downloaded or loaded offline
# however this feature is deprecated as offline images can be done with gosu::image anyway

# Image can be drawn with make function. It takes 2 variuables position x and y
# other optional argumets are width and height as a multiplier(2 means the image will be drawn twice as big)
# however the last argument is a boolean which if set to true, the function gets resolution instead of scale.
# not setting the optional arguments the image will be drawn the size it was designed

# download_image is a function that gets the image url and a name(without an extention) and downloads the image into said name with the extention automaticaly detected
# and download the image with final name into JReaders root temp folder. Which later is used as a gosu::image
# using this function is not required as its called automatically after initialization

# reload is a function that is called automatically after download_image is done.
# reload can be manually called. Once called in case of exsistance of download file, it will load it into a gosu::image

# width and height are both functions that in case of file being downloaded, will return original width and height of the image(regardless of assigned scale or resolution)

# visible gets a boolean that sets the images visibility

# got_image will return downloaded image as a gosu::image

class Image < Gosu::Image
  def download_image(url, name)
    filetype = ""
    succes = false

    begin
      d_file = URI.parse(url).read
      puts "link sent to image downloader is #{url}"

      # check if the file extension is 3 characters long
      for char in 1..3
        filetype = url[-char] + filetype
      end
      for formats in $known_filetypes
        if filetype == formats
          succes = true
        end
      end
      if not succes
        # retry with 4 characters
        filetype = ""
        for char in 1..4
          filetype = url[-char] + filetype
        end
        for formats in $known_filetypes
          if filetype == formats
            succes = true
          end
        end
      end
      @downloaded_image = 2
      if succes
        image_file = File.open("temp/#{name}.#{filetype}", "wb")
        image_file.write(d_file)
        image_file.close()
        @filetype = filetype
        @downloaded_image = 1
      end
      # flush the downloaded image from memmory
      d_file = nil
    rescue => error
      puts "IMAGE LOADING CODE BLOCK FAILED WITH ERROR #{error}"
      succes = false
    end
  end

  def reload
    begin
      @got_image = Gosu::Image.new("temp/#{@image_name}.#{@filetype}")
      success = true
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
    # status of downloader
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
      return @got_image.width
    else
      return 0
    end
  end

  def height
    if @got_image.class == Gosu::Image
      return @got_image.height
    else
      return 0
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
      width_valid = height_valid = false

      #validate width and height

      if not width.nil?
        width_valid = true
      end
      if not height.nil?
        height_valid = true
      end

      if not @got_image.nil?
        if got_res
          #resolution is provided
          if width_valid
            scalex = width / @got_image.width.to_f
          end
          if height_valid
            scaley = height / @got_image.height.to_f
          end
        else
          #scale is provided
          if width_valid
            scalex = width
          end
          if height_valid
            scaley = height
          end
        end
        @got_image.draw(posx, posy, 0, scalex, scaley)
      end
    elsif @downloaded_image == 0
      @loading_image.draw(posx, posy)
    else
      @failed_image.draw(posx, posy)
    end
  end

  def visible(to)
    @visible = to
  end

  def got_image
    return @got_image
  end
end

# TextIn is Gosu::TextInput class with Rectangle functionalaties
# initialization requires 4 variuables, width, height, default_text, text_size
# other optional variuables are maximum_letter, padding, background color, text color (foreground)
# TextIn is not a continewation of rectangle. So rectangle draw is a class variuable inside of TextIn.

# since TextIn is not direct continewation of shapes or rectangle, some functions are rewritten such as
# visible, corner_data
# TextIns corner_data does not do any validation. The validation is done by rectangle defined in TextIn instead

# active_chech compares selected textInput of main application. is called automatically at the end of make function

# get_width and get_height returns the supposed text image size.

# clicked function selects the textin as the applications default textinput. for selection to take place make sure 
# the application is updating its active_text to $active_text regularly

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
