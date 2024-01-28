require "./core"

JR().set_instance("https://teddit.zaggy.nl/")

#JR().load_json("")

puts JR().search_options("Hello world", false, false, 2)

=begin
Shoes.app :width => 100, :height => 100 do
    button do alert "yaay You pressed me" end
end
=end
