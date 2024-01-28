require 'json'

js_parsed = JSON.load File.new "download.json"

#puts "#{js_parsed.keys}"

#puts "#{js_parsed["info"]}"


#puts "#{js_parsed["links"].length}"

#puts js_parsed["links"][1].keys

#(0..js_parsed["links"].length).each do |links|
#    puts "#{js_parsed["links"][links]} \n"
#end



#Shoes.app width: 300, height: 200 do
#  background lime..blue
#
#  stack do
#    para "Welcome to the world of Shoes!"
#    button "Click me" do alert "Nice click!" end
#    image "http://shoesrb.com/img/shoes-icon.png",
#          margin_top: 20, margin_left: 10
#  end
#end
