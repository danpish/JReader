require "./core"

$JR = JR.new

Shoes.app width: 800, height: 600 do
  #startup page
  def add_element (data)
    @middle_area.scroll = true
    for place in (0..data["links"].length)
      @middle_area.append {
        stack width: "100%", align: "center", margin_top: 10 do
          stack width: "100%" do
            background "#256", curve: 24
            title data["links"][place]["title"]
          end
        end
      }
    end
  end

  background "#123"
  @left_area = flow width: "20%" do end

  @middle_area = flow width: "60%", height: "100%", margin: 10 do
    @search_box = stack width: "100%", height: 200, align: "center" do
      background "#256", curve: 24
      flow height: "30%" do end
      flow align: "center", margin: 10 do
        para "search something", align: "center"
        edit_line width: -75, align: "center"
        button "search", width: 75, align: "center" do
          @left_area.hide
          @right_area.width = "40%"
          @search_box.hide
          @inform_box.show
          @sub_search_box.show
          add_element
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
              @left_area.hide
              @right_area.width = "40%"
              @search_box.hide
              @inform_box.show
              @sub_search_box.show
              add_element $JR.return_loaded_json
             else
              if not load_failed
                alert "Loading was unsuccessful. Try openning terminal and enable is_debugging in core.rb to get more details."
              end
            end
        end
      end
    end
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