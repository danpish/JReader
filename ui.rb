require "./core"

JR().set_instance("https://teddit.zaggy.nl")

#JR().subreddit_search("dragons", "cool")

JR().get_subreddit("dragons", 1, false, 2)

#JR().load_json("/r/all/" + search_options("Hello world", false, false, 0))

#JR().load_json("download.json", "file")

#puts JR().return_loaded_json["suggested_subreddits"][2]["data"]

JR().write_json("subreddittest2")

=begin
Shoes.app :width => 100, :height => 100 do
    button do alert "yaay You pressed me" end
end
=end
