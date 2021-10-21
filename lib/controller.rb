require_relative 'recipe'
require_relative 'cookbook'
require_relative 'view'
require_relative 'scrap'
require 'open-uri'
require 'nokogiri'

class Controller
  def initialize(cookbook)
    @cookbook = cookbook
    @view = View.new
  end

  def list
    recipes = @cookbook.all
    @view.display(recipes)
  end

  def create
    name = @view.ask_for('name')
    description = @view.ask_for('description')
    rating = @view.ask_for('rating').to_i
    preptime = @view.ask_for('preparation time').to_i
    recipe = Recipe.new(name, description, rating, preptime, false)
    @cookbook.add_recipe(recipe)
  end

  def import
    ingredient = @view.ask_for_ingredient
    scrap = ScrapeAllrecipesService.new(ingredient)
    recipes_of_web = scrap.call
    @view.display_recipes_of_web(recipes_of_web, ingredient)
    index = @view.ask_for_recipe_to_save
    name = recipes_of_web[index][0]
    description = recipes_of_web[index][1]
    rating = recipes_of_web[index][2]
    preptime = recipes_of_web[index][3]
    recipe = Recipe.new(name, description, rating, preptime, false)
    @cookbook.add_recipe(recipe)
  end

  def mark_as_done
    index = @view.ask_for_index
    recipe = @cookbook.find(index)
    recipe.mark_as_done!
    @cookbook.remove_recipe(index)
    recipe = Recipe.new(recipe.name, recipe.description, recipe.rating, recipe.preptime, true)
    @cookbook.add_recipe(recipe)
  end

  def destroy
    list
    index = @view.ask_for_index
    @cookbook.remove_recipe(index)
  end
end
