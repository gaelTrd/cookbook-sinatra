require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require_relative "cookbook"
require_relative "scrap"
configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end



get '/' do
  csv_file   = File.join(__dir__, 'recipes.csv')
  cookbook   = Cookbook.new(csv_file)
  @recipes = cookbook.all
  erb :index
end

post "/add" do
  csv_file   = File.join(__dir__, 'recipes.csv')
  cookbook   = Cookbook.new(csv_file)
  recipe = Recipe.new(params["name"], params["description"], params["rating"], params["preptime"], false)
  cookbook.add_recipe(recipe)
  redirect '/'
end

post "/add-from-web" do
  scrap = ScrapeAllrecipesService.new(params["ingredient"])
  recipes_of_web = scrap.call
  erb :list
end

get '/destroy' do
  csv_file   = File.join(__dir__, 'recipes.csv')
  cookbook   = Cookbook.new(csv_file)
  cookbook.remove_recipe(params["i"].to_i)
  redirect '/'
end

get '/mark-as-done' do
  csv_file   = File.join(__dir__, 'recipes.csv')
  cookbook   = Cookbook.new(csv_file)
  cookbook.mark_as_done(params["i"].to_i)
  redirect '/'
end

get '/new' do
  erb :new
end
