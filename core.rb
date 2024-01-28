require "json"
require "open-uri"

# Global variuables
# Might adjust in ui.rb

$is_debugging = false
$set_inst = nil # setted teddit instance
$sort_by = ["relevance", "hot", "top", "new"]

def ERR(err_message)
  puts "ERROR : #{err_message} \n"
end

def JR()
  def search_options(
    search_query = nil,
    is_nsfw = false,
    limited = false,
    sort_by = 0,
    time = "all" # should also add time span support
    
  )
    f_option = ""

    if search_query != nil
      f_option = f_option + "q=" + search_query + "&"
    end

    f_option = f_option + "t=" + time + "&"

    if is_nsfw
      f_option = f_option + "nsfw=on" + "&"
    end
    f_option = f_option + "sort=" + $sort_by[sort_by]

    if limited
      f_option = "&" + f_option + "restric_sr=" + "on"
    end

    return URI::Parser.new.escape f_option
  end

  def load_json(link, is_local = true) # is_local would be useless if is_debugging is set to false
    if $is_debugging
      if is_local
        $loaded_json = JSON.load File.new(link) # read from file
      else
        $loaded_json = JSON.load URI.parse(link).read # if you want localhost or give full URL
      end
    else
      if $set_inst != nil
        $loaded_json = JSON.load URI.parse($set_inst + link).read
      else
        ERR("instance is not set. Did you forget to set it? or an error accured while setting it! \n debug instance is #{set_inst}")
      end
    end
  end

  def return_loaded_json
    return $loaded_json
  end

  #instance inserted must be a string

  def set_instance(inst)
    if inst != "" || inst != nil
      $set_inst = inst
    else
      ERR("url sent for instance is not acceptable")
      $set_inst = nil
    end
  end
end
