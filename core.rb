require "json"
require "open-uri"

def JR()
    def im_here()
        puts "library loaded successfully "
    end
    
    def load_json(link)
        $loaded_json = JSON.load URI.parse(link).read
    end
    
    def puts_loaded_json
        puts $loaded_json
    end
end