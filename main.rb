require "./ui/dgu"
require "./core"
require "reverse_markdown"

$JR = JR.new
$JRSetting = Settings.new
setting_status = $JRSetting.load_settings

while not setting_status
  setting_status = $JRSetting.load_settings
end



$width, $height = 1024, 720

# common corner radious
$RCG = 30


# scroll potition of the posts
$position = 0

# search posts from /r/popular or go to subreddit
$search_popular = false

# colors
$GBackground_color = Gosu::Color::rgb(23, 38, 44)
$GForeground_color = Gosu::Color::rgb(33, 48, 54)
$GStroke_color = Gosu::Color::rgb(43, 58, 64)

## shapes
#background rectangle
$background_color = Rectangle.new($width, $height, $GBackground_color)

# subreddit explorer background
$starter_back = Rectangle.new($width / 2, 200, $GForeground_color)
$starter_back.corner_data([$RCG, $RCG, $RCG, $RCG])

# subreddit explorer text bar 
$search_subreddit = TextIn.new($width / 2 - 20 - 100, 100, "subreddit", 40, nil, 25)
$search_subreddit.corner_data([$RCG, 0, $RCG, 0])

# subreddit search text bar
$subreddit_search = TextIn.new(100, 50, "", 15, nil, 15)
$subreddit_search.corner_data([$RCG, 0, $RCG, 0])
$subreddit_search.visible(false)

# posts info
$posts_background = nil
$post_titles = nil
$post_images = nil

def is_subreddit_searched
  if $JR.return_loaded_json.nil?
    return nil
  elsif $JR.return_loaded_json["links"].nil?
    return "posts"
  else
    return "links"
  end
end

def sort_results(mode)
  reset_temp
  if not is_subreddit_searched().nil?
    if is_subreddit_searched() == "links"
      $JR.get_subreddit($search_subreddit.text, mode)
      results false
    else
      if $search_popular
        $JR.subreddit_search("popular", $search_subreddit.text, $def_nsfw, mode + 1)
      else
        $JR.subreddit_search($search_subreddit.text, $subreddit_search.text, $def_nsfw, mode + 1)
      end
      results true
    end
  end
end

class Button_new < Button
  def job
    sort_results(2)
  end
end

class Button_top < Button
  def job
    sort_results(1)
  end
end

class Button_hot < Button
  def job
    sort_results(0)
  end
end

class Button_relevance < Button
  def job
    reset_temp
    if not is_subreddit_searched().nil?
      if is_subreddit_searched() == "posts"
        if $search_popular
          $JR.subreddit_search("popular", $search_subreddit.text, $def_nsfw, 0)
        else
          $JR.subreddit_search($search_subreddit.text, $subreddit_search.text, $def_nsfw, 0)
        end
        results true
      end
    end
  end
end

def add_sort_buttons(subreddit_search)
  button_amount = 3
  if subreddit_search
    button_amount = 4
  end
  $button_new = Button_new.new(($width - 200 - 35 - 20) / button_amount, 40, "new", Gosu::Color::CYAN, 20, 10)
  $button_top = Button_top.new(($width - 200 - 35 - 20) / button_amount, 40, "top", Gosu::Color::CYAN, 20, 10)
  $button_hot = Button_hot.new(($width - 200 - 35 - 20) / button_amount, 40, "hot", Gosu::Color::CYAN, 20, 10)
  if subreddit_search
    $button_relevance = Button_relevance.new(($width - 200 - 35 - 20) / button_amount, 40, "relev", Gosu::Color::CYAN, 20, 10)
  end
end

add_sort_buttons(false)

def reset_temp
  if File.directory?("temp")
    FileUtils::rm_r("temp")
  end
  FileUtils::mkdir("temp")
end

class ScrollThrough < Slider
  def on_change(pers)
    $position = pers
  end
end

class SubredditSearchButton < Button
  def job
    subreddit_search = false
    if @text == "go"
      puts $JR.get_subreddit($search_subreddit.text)
      $search_popular = false
    else
      puts $JR.subreddit_search("popular", $search_subreddit.text)
      $search_popular = true
      subreddit_search = true
    end
    puts $JR.return_loaded_json.nil?
    if not $JR.return_loaded_json.nil?
      hide_main_menu
      results subreddit_search
      add_sort_buttons subreddit_search
    end
  end
end

class SearchSubreddit < Button
  def job
    reset_temp
    puts $JR.subreddit_search($search_subreddit.text, $subreddit_search.text)
    puts $JR.return_loaded_json.nil?
    if not $JR.return_loaded_json.nil?
      hide_main_menu
      results true
      add_sort_buttons true
    end
  end
end

def main_menu_button(is_popular)
  text = "go"
  if is_popular
    text = "search"
  end
  $search_subreddit_button = SubredditSearchButton.new(100, 100, text, Gosu::Color::CYAN, 25, 30)
  $search_subreddit_button.corner_data([0, $RCG, 0, $RCG])
end

main_menu_button(false)

class Set_popular < Button
  def job
    main_menu_button(true)
  end
end

class Set_subreddit < Button
  def job
    main_menu_button(false)
  end
end

$Set_popular = Set_popular.new($width / 4 - 10, 50, "r/popular", Gosu::Color::CYAN, 25, 10)
$Set_subreddit = Set_subreddit.new($width / 4 - 10, 50, "subreddit", Gosu::Color::CYAN, 25, 10)
$Set_popular.corner_data([$RCG,0,$RCG,0])
$Set_subreddit.corner_data([0,$RCG,0,$RCG])

$subreddit_search_button = SearchSubreddit.new(80, 50, "search", Gosu::Color::CYAN, 20, 10)
$subreddit_search_button.corner_data([0, $RCG, 0, $RCG])
$subreddit_search_button.visible(false)

class Return_main_menu < Button
  def job
    $search_subreddit_button.visible(true)
    $search_subreddit.visible(true)
    $starter_back.visible(true)
    $Set_popular.visible(true)
    $Set_subreddit.visible(true)
    
    $subreddit_about.visible(false)
    $subreddit_search_button.visible(false)
    $subreddit_search.visible(false)
    
    $posts_background = Array.new(0)
    $post_titles = Array.new(0)
    $post_images = Array.new(0)
    $post_texts = Array.new(0)
  end
end

$Return_main_menu = Return_main_menu.new(100,50, "Back", Gosu::Color::CYAN, 20, 10)
$Return_main_menu.corner_data([$RCG,$RCG,$RCG,$RCG])

def hide_main_menu
  $search_subreddit_button.visible(false)
  $search_subreddit.visible(false)
  $starter_back.visible(false)
  $Set_popular.visible(false)
  $Set_subreddit.visible(false)
end

$subreddit_about = Rectangle.new(200, 400, $GForeground_color)
$subreddit_about.corner_data([$RCG, $RCG, $RCG, $RCG])
$subreddit_about.visible(false)


def results(subreddit_search)
  $subreddit_about.visible(true)
  $subreddit_search_button.visible(true)
  $subreddit_search.visible(true)
  $Set_popular.visible(false)
  $Set_subreddit.visible(false)
  
  $posts_background = Array.new(0)
  $post_titles = Array.new(0)
  $post_images = Array.new(0)
  $post_texts = Array.new(0)

  # posts from normal subreddit and searching the subreddit are different
  # for more info visit https://codeberg.org/teddit/teddit/wiki#teddit-api
  search = "links" # normal subreddit browsing
  if subreddit_search 
    search = "posts" # searching subreddit
  end
  
  DBG("main", __LINE__, "#{search} #{subreddit_search}")
  for post in 0..$JR.return_loaded_json[search].length - 1
    
    $posts_background.push(Rectangle.new($width - 200 - 45, 440, $GForeground_color))
    $posts_background[post].corner_data([$RCG, $RCG, $RCG, $RCG])
    $post_titles.push(Gosu::Image.from_text($JR.return_loaded_json[search][post]["title"], 20, width: $width - 200 - 45))

    
    if not $JR.return_loaded_json[search][post]["images"].nil?
      # try to download full images. download thumbnail instead if the media is unsupported  
      if $JR.return_loaded_json[search][post]["images"].key?("preview")
        if not $JR.return_loaded_json[search][post]["images"]["preview"].nil?
          $post_images.push(Image.new($JR.return_full_image(post), post.to_s))
        else
          $post_images.push(Image.new($JR.return_loaded_json[search][post]["images"]["thumb"], post.to_s))
        end
      else
        $post_images.push(Image.new($JR.return_loaded_json[search][post]["images"]["thumb"], post.to_s))
      end
    else
      $post_images.push(nil)
    end
    
    if not $JR.return_loaded_json[search][post]["selftext_html"].nil?
      $post_texts.push(Gosu::Image.from_markup(ReverseMarkdown.convert($JR.return_loaded_json[search][post]["selftext_html"]), 20, width: $width - 200 - 45))
    else
      $post_texts.push(nil)
    end
  end
  
  $slide = ScrollThrough.new($height - 20, 0, (440 + 10) * ($posts_background.length - 1))
end

class JReader < Gosu::Window
  def initialize
    super $width, $height
    self.caption = "jreader - dev"
    reset_temp
  end

  def update
    $search_subreddit_button.update(mouse_x, mouse_y)
    $subreddit_search_button.update(mouse_x, mouse_y)
    $button_new.update(mouse_x, mouse_y)
    $button_top.update(mouse_x, mouse_y)
    $button_hot.update(mouse_x, mouse_y)
    $Return_main_menu.update(mouse_x, mouse_y)
    if not $button_relevance.nil?
      $button_relevance.update(mouse_x, mouse_y)
    end
    $Set_popular.update(mouse_x, mouse_y)
    $Set_subreddit.update(mouse_x, mouse_y)
    if not $slide.nil?
      $slide.change(mouse_x, mouse_y, button_down?(256))
    end
  end

  def draw
    # background color
    $background_color.make(0, 0)

    stroke true
    stroke_weigh = 10
    stroke_color $GStroke_color

    # main search area
    $starter_back.make($width / 2 - ($width / 4), 10)
    $Set_popular.add($width / 2 - ($width / 4) + 10, 30)
    $Set_subreddit.add($width / 2 - ($width / 4) + 10 + $Set_popular.width, 30)
    $search_subreddit.make(self, $width / 2 - ($width / 4) + 10, 80)
    $search_subreddit_button.add($width - 10 - 100 - ($width / 4), 80)
    # about subreddit area (seriously teddit. where can I get subreddit info)
    $subreddit_about.make($width - 200 - 10, 10)
    $subreddit_search_button.add($width - 200 + 100, 40)
    $subreddit_search.make(self, $width - 200, 40)
    
    if $posts_background.class == Array and $subreddit_about.visible?
      curr_post = 0
      dbg_hidden_posts = 0
      
      for post in $posts_background     
        post_pos = 10 * curr_post + curr_post * 440

        # check if posts are inside of main screen
        if post_pos + 440 > $position and post_pos < $position + $width
          $posts_background[curr_post].make(10, post_pos - $position + 50)

          if not $post_images[curr_post].nil?
            aspect_size = 1
            post_height = 0
            
            if not $post_texts[curr_post].nil?
              post_height = $post_texts[curr_post].height
            end
            
            # fitting the image inside of the post 
            if $post_images[curr_post].width > $width - 200 - 65
              aspect_size = ($width - 200 - 65) / $post_images[curr_post].width.to_f
            end
            if $post_images[curr_post].height * aspect_size > 420 - $post_titles[curr_post].height - post_height
              aspect_size = (420.0 - $post_titles[curr_post].height - post_height) / $post_images[curr_post].height
            end
            
            $post_images[curr_post].make(20, 10 * curr_post + curr_post * 440 - $position + 60 + $post_titles[curr_post].height, aspect_size, aspect_size, false)
          
          end
          
          if not $post_texts[curr_post].nil?
            $post_texts[curr_post].draw(20, 10 * curr_post + curr_post * 440 - $position + 490 - $post_texts[curr_post].height)
          end
          
          $post_titles[curr_post].draw(20, 10 * curr_post + curr_post * 440 - $position + 60)
        else
          dbg_hidden_posts += 1
        end
        curr_post += 1
      end
      ## DEBUG PRINT NON DRAWING POSTS
      # DBG("main", __LINE__, "#{dbg_hidden_posts}")

      # top bar (sorting buttons)
      draw_rect(0, 0, $width - 200 - 35, 50, $GBackground_color)
      $button_new.add(5, 5)
      $button_top.add($button_new.width + 5, 5)
      $button_hot.add($button_new.width + $button_top.width + 5, 5)
      if not $button_relevance.nil?
        $button_relevance.add($button_new.width + $button_top.width + $button_hot.width  + 5, 5)
      end
      $Return_main_menu.add($width - 110, 410)
      $slide.make($width - 200 - 35, 10)
    end
    pop
  end

  def button_up(key)
    if key == 256
      $search_subreddit.clicked(mouse_x, mouse_y)
      $search_subreddit_button.clicked(mouse_x, mouse_y)
      $subreddit_search_button.clicked(mouse_x, mouse_y)
      $subreddit_search.clicked(mouse_x, mouse_y)
      $button_new.clicked(mouse_x, mouse_y)
      $button_top.clicked(mouse_x, mouse_y)
      $button_hot.clicked(mouse_x, mouse_y)
      $Set_popular.clicked(mouse_x, mouse_y)
      $Set_subreddit.clicked(mouse_x, mouse_y)
      $Return_main_menu.clicked(mouse_x, mouse_y)
      if not $button_relevance.nil?
        $button_relevance.clicked(mouse_x, mouse_y)
      end
    end
    self.text_input = $active_text
  end
end

JReader.new.show
