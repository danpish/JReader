require "json"

$randfunc = Random.new()

js_parsed = JSON.load File.new "download.json"

#puts "#{js_parsed.keys}"

#puts "#{js_parsed["info"]}"

#puts "#{js_parsed["links"].length}"

#puts js_parsed["links"][1].keys

#(0..js_parsed["links"].length).each do |links|
#    puts "#{js_parsed["links"][links]} \n"
#end

instance = "http://teddit.zaggy.nl"
rand_link = $randfunc.rand(js_parsed["links"].length)
$image_url = instance + js_parsed["links"][rand_link]["images"]["preview"]
puts $image_url


Shoes.app width: 300, height: 200 do
    background lime..blue
    
    stack do
        para "Welcome to the world of Shoes!"
        button "Click me" do alert "Nice click!" end
        image $image_url,
            margin_top: 20, margin_left: 10
    end
end
