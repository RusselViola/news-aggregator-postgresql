require "sinatra"
require "pg"
require_relative "./app/models/article"
require 'CSV'
require 'pry'
require_relative "./app/models/input_validation"
require 'uri'

set :views, File.join(File.dirname(__FILE__), "app", "views")

configure :development do
  set :db_config, { dbname: "news_aggregator_development" }
end

configure :test do
  set :db_config, { dbname: "news_aggregator_test" }
end

def db_connection
  begin
    connection = PG.connect(Sinatra::Application.db_config)
    yield(connection)
  ensure
    connection.close
  end
end


get '/' do
  redirect '/articles'
end

get '/articles' do
  db_connection do |conn|
  @tables = conn.exec("SELECT * FROM articles")
  end
  erb :index
end

get '/articles/new' do
  erb :new_article
end

post '/articles/new' do
  @url = params[:article_url]
  @title = params[:article_title]
  @description = params[:article_description]

  if Input_valid.invalid_url?(@url)
    @input_error = true
    erb :new_article
  elsif @description.length < 20
    @char_error = "Description must be 20 characters or more"
    erb :new_article
  elsif @url != '' && @title != '' && @description != ''
    db_connection do |conn|
      conn.exec_params("INSERT INTO articles(title, url, description) VALUES ($1, $2, $3);",
      [@title, @url, @description])
    end
    erb :new_article
    redirect '/articles'
  else
    @error = true
    erb :new_article
  end
end
