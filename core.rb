require "json"
require "open-uri"

# Global variuables
# Might adjust in ui.rb

$is_debugging = false
$set_inst = nil # setted teddit instance
$sort_by = ["relevance", "hot", "top", "new"]

def ERR(place,line ,err_message)
  puts "ERROR #{place.upcase} IN LINE #{line} : #{err_message} \n"
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
      f_option = f_option + "search?q=" + search_query + "&"
    end

    f_option = f_option + "t=" + time + "&"

    if is_nsfw
      f_option = f_option + "nsfw=on" + "&"
    end
    f_option = f_option + "sort=" + $sort_by[sort_by] + "&"

    if limited
      f_option = f_option + "restric_sr=" + "on" + "&"
    end
    f_option = f_option + "api"
    
    return URI::Parser.new.escape f_option # for ruby 3
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
        puts $set_inst + link 
        $loaded_json = JSON.load URI.parse($set_inst + link).read
      else
        ERR("core",__LINE__, "instance is not set. Did you forget to set it? or an error accured while setting it!")
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
      ERR("core",__LINE__, "url sent for instance is not acceptable")
      $set_inst = nil
    end
  end
end
