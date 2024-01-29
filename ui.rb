require "./core"

Shoes.app width: 800, height: 600 do
    #startup page
    background "#123"
    flow width: "20%" do end
    flow width: "60%", margin: 10 do
        stack width: "100%", height: 200,align: "center" do
            background "#256", curve: 24
            flow height: "30%" do end
            flow align: "center", margin: 10 do
                para "search something",align: "center"
                edit_line width: -75,align: "center"
                button "search", width: 75,align: "center"
            end
        end
    end
    flow width: "20%" do end
end