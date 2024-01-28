require "./core"

JR().im_here

JR().load_json("http://127.0.0.1:8000/download.json")

JR().puts_loaded_json

=begin
Shoes.app :width => 100, :height => 100 do
    button do alert "yaay You pressed me" end
end
=end
