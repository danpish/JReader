require "./ui/dgu"
require "./core"

$JR = JR.new
$JRSetting = Settings.new
$JRSetting.load_settings

$width , $height = 1024, 720

$RCG = 30

$position = 0

$GForeground_color = Gosu::Color::rgb(33,48,54)
$GStroke_color = Gosu::Color::rgb(43,58,64)

$starter_back = Rectangle.new($width / 2, 200, $GForeground_color)
$starter_back.corner_data([$RCG,$RCG,$RCG,$RCG])

$search_subreddit = TextIn.new($width / 2 - 20 - 100, 100, "subreddit", 40, nil, 25)
$search_subreddit.corner_data([$RCG,0,$RCG,0])

$posts_background = nil
$post_titles = nil
$post_images = nil

class ScrollThrough < Slider
  def on_change(pers)
    $position = pers
  end
end

class SubredditSearchButton < Button
  
  def job
    puts $JR.get_subreddit($search_subreddit.text)
    puts $JR.return_loaded_json.nil?
    if not $JR.return_loaded_json.nil?
      hide_main_menu
      results
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

$subreddit_about = Rectangle.new(200, 400,$GForeground_color)
$subreddit_about.corner_data([$RCG,$RCG,$RCG,$RCG])
$subreddit_about.visible(false)

def results
  $subreddit_about.visible(true)
  $posts_background = Array.new(0)
  $post_titles = Array.new(0)
  $post_images = Array.new(0)
  for post in 0..$JR.return_loaded_json["links"].length - 1 do
    $posts_background.push(Rectangle.new($width - 200 - 45, 440, $GForeground_color))
    $posts_background[post].corner_data([$RCG,$RCG,$RCG,$RCG])
    $post_titles.push(Gosu::Image.from_text($JR.return_loaded_json["links"][post]["title"], 20 , width: $width - 200 - 45))
    if not $JR.return_loaded_json["links"][post]["images"].nil?
      $post_images.push(Image.new($JR.return_full_image(post), post.to_s))
    else
      $post_images.push(nil)
    end
  end
  $slide = ScrollThrough.new($height - 20, 0, 440 * $posts_background.length)
end

class JReader < Gosu::Window
  def initialize
    super $width, $height
    @frames_passed = 0
    if File.directory?("temp")
      FileUtils::rm_r("temp")
    end
    FileUtils::mkdir("temp")
  end
  
  def update
    $subreddit_search_button.update(mouse_x, mouse_y)
    if not $slide.nil?
      $slide.change(mouse_x, mouse_y, button_down?(256))
    end
  end
  
  def draw
    @frames_passed += 1
    stroke true
    stroke_weigh = 10
    stroke_color $GStroke_color
    $starter_back.make($width / 2 - ($width / 4), 10)
    $search_subreddit.make(self, $width / 2 - ($width / 4) + 10, 60)
    $subreddit_search_button.add($width - 10 - 100 - ($width / 4) , 60)
    $subreddit_about.make($width - 200 - 10 , 10)
    if $posts_background.class == Array and $subreddit_about.visible?
      curr_post = 0
      for post in $posts_background do
        $posts_background[curr_post].make(10, 10 * curr_post + curr_post * 440 - $position)
        $post_titles[curr_post].draw(20, 10 * curr_post + curr_post * 440 - $position + 10)
        if not $post_images[curr_post].nil?
          $post_images[curr_post].make(20 , 10 * curr_post + curr_post * 440 - $position + 30, 600, 400)
          if @frames_passed / 60 == 30
            $post_images[curr_post].reload
          end
        end
        curr_post += 1
      end
      $slide.make($width - 200 - 35 , 10)
    end
    if @frames_passed / 60 == 30
      @frames_passed = 0
    end
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