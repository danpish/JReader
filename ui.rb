require "./core"

$JR = JR.new
$JRSetting = Settings.new
$JRSetting.load_settings

Shoes.app width: 800, height: 600, title: "JReader dev" do
  #startup page
  def add_element(data)
    @middle_area.scroll = true
    for place in (0..data["links"].length)
      @middle_area.append {
        stack width: "100%", align: "center", margin_top: 10 do
          stack width: "100%" do
            background "#256", curve: 24
            stroke "#FFF"
            caption data["links"][place]["title"], margin_left: 10, margin_right: 10
            if data["links"][place]["images"]["thumb"].class == String
              image data["links"][place]["images"]["thumb"], margin_bottom: 7, margin_left: 7
            else
              DBG("ui", __LINE__, "image link is not viable : #{data["links"][place]["images"]}")
            end
          end
        end
      }
    end
  end

  def goto_results()
    @left_area.hide
    @right_area.width = "40%"
    @search_box.hide
    @inform_box.show
    @sub_search_box.show
  end

  def settings_start()
    @search_box.toggle
    @settings_menu.toggle
    if @settings_button.text == "settings"
      @settings_button.text = "<="
    else
      @settings_button.text = "settings"
    end
  end

  background "#123"
  @left_area = flow width: "20%" do
    @settings_button = button "settings" do settings_start end
  end

  @middle_area = flow width: "60%", height: "100%", margin: 10 do
    @search_box = stack width: "100%", height: 200, align: "center" do
      background "#256", curve: 24
      flow align: "center", margin: 10 do
        para "put a subreddit", margin_top: "39%", align: "center"
        search_line = edit_line width: -75, align: "center"
        button "search", width: 75, align: "center" do
          begin
            did_download = $JR.get_subreddit(search_line.text())
            if did_download
              json = $JR.return_loaded_json
            end
          rescue
            ERR("ui", __LINE__, "core.rb is not accessible")
            load_failed = true
          end
          if json
            #alert "library successfully loaded"
            goto_results
            add_element $JR.return_loaded_json
          else
            if not load_failed
              alert "Loading was unsuccessful. Try openning terminal and enable is_debugging in core.rb to get more details."
            end
          end
        end
        button "load json", width: "100%", align: "center" do
          begin
            json = $JR.load_json("download.json", "file")
          rescue
            ERR("ui", __LINE__, "core.rb is not accessible")
            load_failed = true
          end
          if json
            #alert "library successfully loaded"
            goto_results
            add_element $JR.return_loaded_json
          else
            if not load_failed
              alert "Loading was unsuccessful. Try openning terminal and enable is_debugging in core.rb to get more details."
            end
          end
        end
      end
    end

    @settings_menu = stack width: "100%", height: 200, align: "center" do
      background "#256", curve: 24
      stack width: "100%", height: "100%", margin: 10 do
        para "settings\ndefault values", align: "center"
        @def_inst = edit_line width: "100%"
        @def_lim = check; para "limit search to subreddit"
        @def_nsfw = check; para "is nsfw enabled?"
        @def_inst.text = $set_inst
        @def_lim.checked = $def_lim
        @def_nsfw.checked = $def_nsfw
        
        flow width: "100%", align: "center" do
          button "apply" do
            did_change = false
            if @def_inst.text != $set_inst
              $JRSetting.chng_setting("inst", @def_inst.text)
              did_change = true
            end
            if @def_lim.checked? != $def_lim
              $JRSetting.chng_setting("lim", @def_lim.checked?)
              did_change = true
            end
            if @def_nsfw.checked? != $def_nsfw
              $JRSetting.chng_setting("nsfw", @def_nsfw.checked?)
              did_change = true
            end
            if not did_change
              alert "no changes has been applied"
            else
              $JRSetting.load_settings
            end
          end
          button "cancel" do
            @def_inst.text = $set_inst
            @def_lim.checked = $def_lim
            @def_nsfw.checked = $def_nsfw
          end
        end
      end
    end
    @settings_menu.hide
  end

  @right_area = flow width: "20%", height: "100%", margin: 10 do
    @inform_box = stack width: "100%", height: "60%", align: "center" do
      background "#256", curve: 24
    end
    @sub_search_box = stack width: "100%", height: "20%", align: "center", margin_top: 10 do
      background "#256", curve: 24
    end
    @inform_box.hide
    @sub_search_box.hide
  end
end
