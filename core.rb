require "json"
require "open-uri"

# Global variuables
# Might adjust in ui.rb

$is_debugging = true
$set_inst = nil # setted teddit instance
$sort_by = ["relevance", "hot", "top", "new"]
$type = ["hot", "top", "new"]
$time_table = ["hour", "24hour", "week", "month", "year", "all"]
$rand_func = Random.new()

def ERR(place, line, err_message)
  puts "ERROR #{place.upcase} IN LINE #{line} : #{err_message} \n"
end

def debug(place, line, dbg_message)
  puts "DEBUG #{place.upcase} IN LINE #{line} : #{dbg_message} \n"
end

def JR()
  def search_options(
    search_query = nil,
    is_nsfw = false,
    limited = false,
    sort_by = 0,
    time = 5 # useless if sorted_by is not set to "top" or 2
    
  )
    f_option = ""

    if search_query != nil
      f_option = f_option + "search?q=" + search_query + "&"
    end

    f_option = f_option + "t=" + $time_table[time] + "&"

    if is_nsfw
      f_option = f_option + "nsfw=on" + "&"
    end
    f_option = f_option + "sort=" + $sort_by[sort_by] + "&"

    if limited
      f_option = f_option + "restric_sr=" + "on" + "&"
    end
    f_option = f_option + "api"

    return URI::Parser.new.escape f_option # returns a string like url. Only works for ruby 3+
  end

  def load_json(link, local_type = nil)
    if local_type.class == String
      if local_type == "file"
        $loaded_json = JSON.load File.new(link) # read from file
      else
        $loaded_json = JSON.load URI.parse(link).read # if you want localhost or give full URL
      end
    else
      if $set_inst != nil
        if $is_debugging
          debug("core", __LINE__, "link sent to url parser is #{$set_inst + link}")
        end
        $loaded_json = JSON.load URI.parse($set_inst + link).read
      else
        ERR("core", __LINE__, "instance is not set. Did you forget to set it? or an error accured while setting it!")
      end
    end
  end

  def return_loaded_json
    return $loaded_json
  end

  #instance inserted must be a string and should not have / at the end

  def set_instance(inst)
    if inst.class == String
      $set_inst = inst
    else
      ERR("core", __LINE__, "url sent for instance is not acceptable")
      $set_inst = nil
    end
  end

  def write_json(name = nil)
    f_name = "debug#{$rand_func.rand()}.json"
    if name.class == String
      f_name = "debug#{name}.json"
    end
    File.write(f_name, JSON.generate($loaded_json))
  end

  def subreddit_search(
    subreddit = "all", # default is /r/all
    search_query = nil,
    is_nsfw = false,
    sort_by = 0,
    time = 5
  )
    if search_query.class == String
      load_json("/r/#{subreddit}/" + search_options(search_query, is_nsfw, true, sort_by, time))
    else
      ERR("core", __LINE__, "subreddit search query cannot be empty")
    end
  end

  def get_subreddit(
    subreddit = "all",
    type = 0,
    is_nsfw = false,
    time = 5
  )
    new_page_api = true # should url generator add "/?api" to the end or not
    link = "/r/#{subreddit}"
    if type != 0
      link = link + "/#{$type[type]}"
    end
    if type == 1 and time != 1
      link = link + "?t=" + $time_table[time] + "&api"
      new_page_api = false
    end
    if new_page_api
      link = link + "/?api"
    end
    load_json(link)
  end
end
