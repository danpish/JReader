require "./core"

JR().set_instance(736)

JR().load_json("/r/all/" + search_options("Hello world", false, false, 0), false)

puts JR().return_loaded_json

=begin
Shoes.app :width => 100, :height => 100 do
    button do alert "yaay You pressed me" end
end
=end
