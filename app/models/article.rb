require_relative './app/models/input_validation'
class Article
  attr_reader :title, :url, :description, :errors
  def initialize(article = {})
    @title = article["title"]
    @url = article["url"]
    @description = article["description"]
    @errors = []
  end

  def self.all
    articles = []
    db_connection do |conn|
      db_output = conn.exec("SELECT * FROM articles")
      db_output.each do |article|
        articles << Article.new(article)
      end
    end
    articles
  end

  def  valid?
    @error.empty?
  end

end
