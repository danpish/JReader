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

$def_nsfw = false
$def_lim = false
$def_sort = 0
$def_time = 5
$def_type = 0

# ERR gets a string, an integer and a string as input
# prints message on terminal
# example : ERR("core", __LINE__, "this is a message that will get print")

def ERR(place, line, err_message)
  puts "ERROR #{place.upcase} IN LINE #{line} : #{err_message} \n"
end

# DBG is similar to ERR in term of input and output
# in order of DBG to work, global variuable $is_debugging must be true
# example : DBG("core", __LINE__, "this is a message that will get print. but only if $is_debugging is set to true")

def DBG(place, line, dbg_message)
  if $is_debugging
    puts "DEBUG #{place.upcase} IN LINE #{line} : #{dbg_message} \n"
  end
end

def url_encode(string)
  rplc = { " " => "+" }
  return string.gsub(" ", rplc)
end

class JR
  # a function that will return true under any condition
  # can be used to detect if core.rb is loaded

  def is_loaded()
    return true
  end

  # search_options inputs, listed in order are : string, bool, bool, integer, integer
  # return a string encoded url style. must be used with other urls.

  def search_options(
    search_query = nil,
    is_nsfw = $def_nsfw,
    limited = $def_lim,
    sort_by = $def_sort,
    time = $def_time # useless if sorted_by is not set to "top" or 2
    
  )
    f_option = ""

    if search_query != nil
      f_option = f_option + "search?q=" + search_query + "&"
    end

    if limited
      f_option = f_option + "restrict_sr=on" + "&"
    end
    
    f_option = f_option + "t=" + $time_table[time] + "&"

    if is_nsfw
      f_option = f_option + "nsfw=on" + "&"
    end
    f_option = f_option + "sort=" + $sort_by[sort_by] + "&"

    f_option = f_option + "api"

    return url_encode f_option # returns a string like url. Only works for ruby 3+
  end

  #load_json gets 2 strings, address(file or url) and a address type
  #returns true or false depending on sucess of procedure

  def load_json(link, local_type = nil)
    begin
      if local_type.class == String
        if local_type == "file"
          $loaded_json = JSON.load File.new(link) # read from file
        else
          $loaded_json = JSON.load URI.parse(link).read # if you want localhost or give full URL
        end
      else
        if not $set_inst.nil?
          DBG("core", __LINE__, "link sent to url parser is #{$set_inst + link}")
          $loaded_json = JSON.load URI.parse($set_inst + link).read
        else
          ERR("core", __LINE__, "instance is not set. Did you forget to set it? or an error accured while setting it!")
          return false
        end
      end
      return true
    rescue
      ERR("CORE", __LINE__, "load_json codeblock failed with error #{error}")
      return false
    end
  end

  #return_loaded_json returns a hash or array depending on json file it loaded

  def return_loaded_json
    return $loaded_json
  end

  #instance given must be a string and should not have / at the end

  def set_instance(inst)
    if inst.class == String
      $set_inst = inst
    else
      ERR("core", __LINE__, "url sent for instance is not acceptable")
      $set_inst = nil
    end
  end

  # write_json gets a string
  # dumps the json loaded in the memory into afile with the given name or with a random float number
  #

  def write_json(name = nil)
    f_name = "debug#{$rand_func.rand()}.json"
    if name.class == String
      f_name = "debug#{name}.json"
    end
    begin
      File.write(f_name, JSON.generate($loaded_json))
      return true
    rescue
      ERR("core", __LINE__, "writing json file failed")
      return false
    end
  end

  # subreddit_search extends search_options function and does it in a specific subreddit
  # gets string, string, bool, integer, integer

  def subreddit_search(
    subreddit = "all", # default is /r/all
    search_query = nil,
    is_nsfw = $def_nsfw,
    sort_by = $def_sort,
    time = $def_time
  )
    if search_query.class == String
      load_json("/r/#{subreddit}/" + search_options(search_query, is_nsfw, true, sort_by, time))
    else
      ERR("core", __LINE__, "subreddit search query cannot be empty")
    end
  end

  # get_subreddit gets a string, integer, bool, integer
  # if successful returns a hash containing all information in a subreddit homepage

  def get_subreddit(
    subreddit = "all",
    type = $def_type,
    is_nsfw = $def_nsfw,
    time = $def_time
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
    link = url_encode link
    load_json(link)
    return link # this is here for testing purposes i will do later
  end

  # return_preview_image gets an integer and returns an url as string or false apon failure

  def return_full_image(post)
    posts = "links"
    if $loaded_json["links"].nil?
      posts = "posts"
    end
    if $set_inst.class != String
      ERR("core", __LINE__, "instance is not set correctly")
      return false
    end
    if $loaded_json[posts][post]["images"].nil? or $loaded_json[posts][post]["images"]["preview"].nil?
      DBG("core", __LINE__, "post does not have any image")
      return false
    end
    #DBG("core", __LINE__, "search form is #{posts}")
    #DBG("core", __LINE__, $loaded_json[posts][post]["images"]["preview"])
    return $set_inst + $loaded_json[posts][post]["images"]["preview"]
  end
end

$def_settings = { inst: "https://teddit.zaggy.nl", nsfw: false, time: 5, limit: false, sort_by: 0, type: 0 }
$settings = nil

class Settings
  def load_settings(specific_file = nil)
    begin
      if specific_file.class != String
        file = File.read("settings.json")
      else
        file = File.read(specifig_file)
      end
      DBG("core", __LINE__, "settings file has been loaded")
      $settings = JSON.load file

      #validate
      json_is_valid = false
      if $settings["inst"].class != String
        ERR("core", __LINE__, "config file is not valid. modify \"inst\" in settings.json.")
        return false
      elsif $settings["limit"].class != TrueClass and $settings["limit"].class != FalseClass
        ERR("core", __LINE__, "config file is not valid. modify \"limit\" in settings.json.")
        return false
      elsif $settings["time"].class != Integer
        ERR("core", __LINE__, "config file is not valid. modify \"time\" in settings.json.")
        return false
      elsif $settings["sort_by"].class != Integer
        ERR("core", __LINE__, "config file is not valid. modify \"sort_by\" in settings.json.")
        return false
      elsif $settings["type"].class != Integer
        ERR("core", __LINE__, "config file is not valid. modify \"type\" in settings.json.")
        return false
      elsif $settings["nsfw"].class != TrueClass and $settings["nsfw"].class != FalseClass
        ERR("core", __LINE__, "config file is not valid. modify \"nsfw\" in settings.json.")
        return false
      else
        #validate phase 2
        if not($settings["time"] < $time_table.length and $settings["time"] >= 0)
          ERR("core", __LINE__, "value set for a setting is not valid. modify \"time\" in settings.json. it should be a number between 0 and #{$time_table.length - 1} but it is #{$settings["time"]}")
          return false
        elsif not($settings["sort_by"] < $sort_by.length and $settings["sort_by"] >= 0)
          ERR("core", __LINE__, "value set for a setting is not valid. modify \"sort_by\" in settings.json. it should be a number between 0 and #{$sort_by.length - 1} but it is #{$settings["sort_by"]}")
          return false
        elsif not($settings["type"] < $type.length and $settings["type"] >= 0)
          ERR("core", __LINE__, "value set for a setting is not valid. modify \"type\" in settings.json. it should be a number between 0 and #{$type.length - 1} but it is #{$settings["type"]}")
          return false
        else
          DBG("core", __LINE__, "validating was successful")
          json_is_valid = true
        end
      end
      if json_is_valid
        $set_inst = $settings["inst"]
        $def_lim = $settings["limit"]
        $def_time = $settings["time"]
        $def_sort = $settings["sort_by"]
        $def_type = $settings["type"]
        $def_nsfw = $settings["nsfw"]
        DBG("core", __LINE__, "loaded settings and they are instance: #{$set_inst} is_limited: #{$def_lim} top_time: #{$def_time} sort_order: #{$def_sort} result_type: #{$def_type} is_nsfw: #{$def_nsfw}")
      end
      return true
    rescue
      ERR("core", __LINE__, "file does not exsist or loading failed somehow")
      write_settings(true)
      return false
    end
  end

  def write_settings(reset)
    if reset
      DBG("core", __LINE__, "writing settings #{$def_settings}")
      json = JSON.generate($def_settings)
    else
      DBG("core", __LINE__, "writing settings #{$settings}")
      json = JSON.generate($settings)
    end
    file = File.open("settings.json", "w")
    file.write(json)
    file.close
  end

  def get_settings()
    return $settings
  end

  def chng_setting(type, value)
    case (type)
    when "inst"
      $settings["inst"] = value
    when "lim"
      $settings["limit"] = value
    when "time"
      $settings["time"] = value
    when "sort"
      $settings["sort_by"] = value
    when "type"
      $settings["type"] = value
    when "nsfw"
      $settings["nsfw"] = value
    else
      ERR("core", __LINE__, "unsupported setting is given")
    end
    write_settings(false)
  end

  def return_curr_defaults()
    puts $def_lim, $def_sort, $def_type, $def_time, $set_inst, $def_nsfw
  end
end
