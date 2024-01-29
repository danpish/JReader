require "./core"

Shoes.app width: 800, height: 600 do
    #startup page
    flow width: "20%" do end
    flow width: "60%" do
        stack width:"100%", height: 200 do
            button "woow", width: "100%", height: "100%" do alert "it works" end
        end
    end
    flow width: "20%" do end
end