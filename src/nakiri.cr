require "crest"
require "lexbor"
require "option_parser"

module Nakiri
  VERSION = "0.1.0"

  url : String? = nil
  selector = ""
  attribute : String? = nil
  output_type = "outer"  # Default to outer html for backwards compatibility

  OptionParser.parse do |parser|
    parser.banner = "Usage: nakiri [arguments]\n\n" \
                   "Reads HTML from URL or stdin if no URL provided"

    parser.on("-u URL", "--url=URL", "URL to scrape (optional)") { |value| url = value }
    parser.on("-s SELECTOR", "--selector=SELECTOR", "CSS selector") { |value| selector = value }
    parser.on("-a ATTR", "--attribute=ATTR", "Attribute to extract (optional)") { |value| attribute = value }
    parser.on("-t TYPE", "--type=TYPE", "Output type: inner or outer (default: outer)") do |value| 
      unless ["inner", "outer"].includes?(value)
        STDERR.puts "ERROR: Output type must be 'inner' or 'outer'"
        exit(1)
      end
      output_type = value
    end
    parser.on("-h", "--help", "Show this help") do
      puts parser
      exit
    end
    
    parser.invalid_option do |flag|
      STDERR.puts "ERROR: #{flag} is not a valid option."
      STDERR.puts parser
      exit(1)
    end
  end

  if selector.empty?
    STDERR.puts "ERROR: CSS selector is required"
    exit(1)
  end

  begin
    html = if url_str = url  # Crystal's if assignment ensures url_str is String
      Crest.get(url_str).body
    else
      STDIN.gets_to_end
    end
    
    document = Lexbor::Parser.new(html)
    
    nodes = document.css(selector)
    if !nodes.empty?
      nodes.each do |node|
        if attr = attribute
          if value = node.attributes[attr]?
            puts value
          end
        else
          puts output_type == "outer" ? node.to_html : node.inner_text
        end
      end
    end
  rescue ex : Crest::RequestFailed
    STDERR.puts "ERROR: Failed to fetch URL (#{ex.response.status_code})"
    exit(1)
  rescue ex
    STDERR.puts "ERROR: #{ex.message}"
    exit(1)
  end
end
