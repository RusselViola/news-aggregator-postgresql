require 'net/http'
require 'uri'
require 'pry'

class Input_valid

  def initialize
  end

  def self.news_input_checker(url, title, description)
    if url == '' || title == '' || description == ''
      true
    else
      false
    end
  end

  def self.invalid_url?(url)
    response = `curl -s -o out.html -w '%{http_code}' #{url}`
    if (/2\d\d/ =~ response) == 0 || (/3\d\d/ =~ response) == 0
      return false
    end
    return true
  end
end
