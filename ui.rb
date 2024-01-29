require "./core"

Shoes.app width: 800, height: 600 do
  #startup page
  def add_element
    @middle_area.scroll = true
    for place in (0..4)
      @middle_area.append {
        stack width: "100%", align: "center", margin_top: 10 do
          stack width: "100%" do
            background "#256", curve: 24
            title "this is #{place} place"
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
          add_element
        end
      end
    end
  end

  @right_area = flow width: "20%", height: "100%", margin: 10 do
    @inform_box = stack width: "100%", height: "100%", align: "center" do
      background "#256", curve: 24
    end
    @inform_box.hide
  end
end
