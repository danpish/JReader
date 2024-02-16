require "./ui/dgu"

class JReader < App
  def draw_window
    draw_circle(50,100,100,25)
  end
end

JReader.new.show