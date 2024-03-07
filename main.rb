require "./ui/dgu"
require "./core"
require "reverse_markdown"

$JR = JR.new
$JRSetting = Settings.new
$JRSetting.load_settings

$width, $height = 1024, 720

$RCG = 30

$position = 0

$GBackground_color = Gosu::Color::rgb(23, 38, 44)
$GForeground_color = Gosu::Color::rgb(33, 48, 54)
$GStroke_color = Gosu::Color::rgb(43, 58, 64)

$background_color = Rectangle.new($width, $height, $GBackground_color)

$starter_back = Rectangle.new($width / 2, 200, $GForeground_color)
$starter_back.corner_data([$RCG, $RCG, $RCG, $RCG])

$search_subreddit = TextIn.new($width / 2 - 20 - 100, 100, "subreddit", 40, nil, 25)
$search_subreddit.corner_data([$RCG, 0, $RCG, 0])

$subreddit_search = TextIn.new(100, 50, "", 15, nil, 15)
$subreddit_search.corner_data([$RCG, 0, $RCG, 0])
$subreddit_search.visible(false)

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

# $type = ["hot", "top", "new"]

def update_sort_buttons
end

class Button_new < Button
  def job
    reset_temp
    if not is_subreddit_searched.nil?
      if is_subreddit_searched == "links"
        $JR.get_subreddit($search_subreddit.text, 2)
        results false
      else
        $JR.subreddit_search($search_subreddit.text, $subreddit_search.text, $def_nsfw, 3)
        results true
      end
    end
    update_sort_buttons
  end
end

class Button_top < Button
  def job
    reset_temp
    if not is_subreddit_searched.nil?
      if is_subreddit_searched == "links"
        $JR.get_subreddit($search_subreddit.text, 1)
        results false
      else
        $JR.subreddit_search($search_subreddit.text, $subreddit_search.text, $def_nsfw, 2)
        results true
      end
    end
    update_sort_buttons
  end
end

class Button_hot < Button
  def job
    reset_temp
    if not is_subreddit_searched.nil?
      if is_subreddit_searched == "links"
        $JR.get_subreddit($search_subreddit.text, 0)
        results false
      else
        $JR.subreddit_search($search_subreddit.text, $subreddit_search.text, $def_nsfw, 1)
        results true
      end
    end
    update_sort_buttons
  end
end

class Button_relevance < Button
  def job
    reset_temp
    if not is_subreddit_searched.nil?
      if is_subreddit_searched == "posts"
        $JR.subreddit_search($search_subreddit.text, $subreddit_search.text, $def_nsfw, 0)
        results true
      end
    end
    update_sort_buttons
  end
end

$button_new = Button_new.new(($width - 200 - 35 - 20) / 4, 40, "new", Gosu::Color::CYAN, 20, 10)
$button_top = Button_top.new(($width - 200 - 35 - 20) / 4, 40, "top", Gosu::Color::CYAN, 20, 10)
$button_hot = Button_hot.new(($width - 200 - 35 - 20) / 4, 40, "hot", Gosu::Color::CYAN, 20, 10)
$button_relevance = Button_relevance.new(($width - 200 - 35 - 20) / 4, 40, "relev", Gosu::Color::CYAN, 20, 10)

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
    puts $JR.get_subreddit($search_subreddit.text)
    puts $JR.return_loaded_json.nil?
    if not $JR.return_loaded_json.nil?
      hide_main_menu
      results false
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
    end
  end
end

$search_subreddit_button = SubredditSearchButton.new(100, 100, "go", Gosu::Color::CYAN, 25, 30)
$search_subreddit_button.corner_data([0, $RCG, 0, $RCG])

$subreddit_search_button = SearchSubreddit.new(80, 50, "search", Gosu::Color::CYAN, 20, 10)
$subreddit_search_button.corner_data([0, $RCG, 0, $RCG])
$subreddit_search_button.visible(false)

def hide_main_menu
  $search_subreddit_button.visible(false)
  $search_subreddit.visible(false)
  $starter_back.visible(false)
end

$subreddit_about = Rectangle.new(200, 400, $GForeground_color)
$subreddit_about.corner_data([$RCG, $RCG, $RCG, $RCG])
$subreddit_about.visible(false)

def results(subreddit_search)
  $subreddit_about.visible(true)
  $subreddit_search_button.visible(true)
  $subreddit_search.visible(true)
  $posts_background = Array.new(0)
  $post_titles = Array.new(0)
  $post_images = Array.new(0)
  $post_texts = Array.new(0)

  search = "links"
  if subreddit_search
    search = "posts"
  end

  for post in 0..$JR.return_loaded_json[search].length - 1
    $posts_background.push(Rectangle.new($width - 200 - 45, 440, $GForeground_color))
    $posts_background[post].corner_data([$RCG, $RCG, $RCG, $RCG])
    $post_titles.push(Gosu::Image.from_text($JR.return_loaded_json[search][post]["title"], 20, width: $width - 200 - 45))
    if not $JR.return_loaded_json[search][post]["images"].nil?
      $post_images.push(Image.new($JR.return_full_image(post), post.to_s))
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
    @frames_passed = 0
    reset_temp
  end

  def update
    $search_subreddit_button.update(mouse_x, mouse_y)
    $subreddit_search_button.update(mouse_x, mouse_y)
    $button_new.update(mouse_x, mouse_y)
    $button_top.update(mouse_x, mouse_y)
    $button_hot.update(mouse_x, mouse_y)
    $button_relevance.update(mouse_x, mouse_y)
    if not $slide.nil?
      $slide.change(mouse_x, mouse_y, button_down?(256))
    end
  end

  def draw
    #background color
    $background_color.make(0, 0)

    @frames_passed += 1
    stroke true
    stroke_weigh = 10
    stroke_color $GStroke_color
    $starter_back.make($width / 2 - ($width / 4), 10)
    $search_subreddit.make(self, $width / 2 - ($width / 4) + 10, 60)
    $search_subreddit_button.add($width - 10 - 100 - ($width / 4), 60)
    $subreddit_about.make($width - 200 - 10, 10)
    $subreddit_search_button.add($width - 200 + 100, 40)
    $subreddit_search.make(self, $width - 200, 40)
    if $posts_background.class == Array and $subreddit_about.visible?
      curr_post = 0
      dbg_hidden_posts = 0
      for post in $posts_background
        post_pos = 10 * curr_post + curr_post * 440
        if post_pos + 440 > $position and post_pos < $position + $width
          $posts_background[curr_post].make(10, post_pos - $position + 50)
          if not $post_images[curr_post].nil?
            aspect_size = 1
            post_height = 0
            if not $post_texts[curr_post].nil?
              post_height = $post_texts[curr_post].height
            end
            if $post_images[curr_post].width > $width - 200 - 65
              aspect_size = ($width - 200 - 65) / $post_images[curr_post].width.to_f
            end
            if $post_images[curr_post].height * aspect_size > 420 - $post_titles[curr_post].height - post_height
              aspect_size = (420.0 - $post_titles[curr_post].height - post_height) / $post_images[curr_post].height
            end
            $post_images[curr_post].make(20, 10 * curr_post + curr_post * 440 - $position + 60 + $post_titles[curr_post].height, aspect_size, aspect_size, false)
            # if @frames_passed / 60 == 30
            #   $post_images[curr_post].reload
            # end
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
      draw_rect(0, 0, $width - 200 - 35, 50, $GBackground_color)
      $button_new.add(5, 5)
      $button_top.add(($width - 200 - 35) / 4 + 5, 5)
      $button_hot.add(($width - 200 - 35) / 2 + 5, 5)
      $button_relevance.add(($width - 200 - 35) / 4 * 3 + 5, 5)
      $slide.make($width - 200 - 35, 10)
    end
    if @frames_passed / 60 == 30
      @frames_passed = 0
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
      $button_relevance.clicked(mouse_x, mouse_y)
    end
    self.text_input = $active_text
  end
end

JReader.new.show
