require "./ui/dgu"
require "./core"

$JR = JR.new
$JRSetting = Settings.new
$JRSetting.load_settings

$width , $height = 1024, 720

$RCG = 30

$starter_back = Rectangle.new($width / 2, 200, Gosu::Color::rgb(33,48,54))
$starter_back.corner_data([$RCG,$RCG,$RCG,$RCG])

$search_subreddit = TextIn.new($width / 2 - 20 - 100, 100, "subreddit", 40, nil, 25)
$search_subreddit.corner_data([$RCG,0,$RCG,0])



class SubredditSearchButton < Button
  
  def job
    puts $JR.get_subreddit($search_subreddit.text)
    puts $JR.return_loaded_json.nil?
    if not $JR.return_loaded_json.nil?
      hide_main_menu
    end
  end
  
end

$subreddit_search_button = SubredditSearchButton.new(100, 100, "search", Gosu::Color::CYAN, 25 , 30)
$subreddit_search_button.corner_data([0,$RCG,0,$RCG])

def hide_main_menu
  $subreddit_search_button.visible(false)
  $search_subreddit.visible(false)
  $starter_back.visible(false)
end

class JReader < Gosu::Window
  def initialize
    super $width, $height 
  end
  
  def update
    $subreddit_search_button.update(mouse_x, mouse_y)
  end
  
  def draw
    stroke true
    stroke_weigh = 10
    stroke_color Gosu::Color::rgb(43,58,64)
    $starter_back.make($width / 2 - ($width / 4), 10)
    $search_subreddit.make(self, $width / 2 - ($width / 4) + 10, 60)
    $subreddit_search_button.add($width - 10 - 100 - ($width / 4) , 60)
    pop
  end
  
  def button_up(key)
    if key == 256
      $search_subreddit.clicked(mouse_x, mouse_y)
      $subreddit_search_button.clicked(mouse_x, mouse_y)
    end
    self.text_input = $active_text
  end
end

JReader.new.show