require 'csv'
require_relative 'recipe'

class Cookbook
  def initialize(csv_file_path)
    @recipes = []
    @csv_file_path = csv_file_path

    load_csv
  end

  def all
    @recipes
  end

  def add_recipe(recipe)
    @recipes << recipe
    CSV.open(@csv_file_path, "w") do |csv|
      @recipes.each do |recipe_to_csv|
        csv << [recipe_to_csv.name, recipe_to_csv.description, recipe_to_csv.rating, recipe_to_csv.preptime, recipe_to_csv.done]
      end
    end
  end

  def find(index)
    @recipes[index]
  end

  def remove_recipe(recipe_index)
    @recipes.delete_at(recipe_index)

    CSV.open(@csv_file_path, "w") do |csv|
      @recipes.each do |recipe_to_csv|
        csv << [recipe_to_csv.name, recipe_to_csv.description, recipe_to_csv.rating, recipe_to_csv.preptime, recipe_to_csv.done]
      end
    end
  end

  def mark_as_done(index)
    recipe = @recipes[index]
    recipe.mark_as_done!
    remove_recipe(index)
    add_recipe(recipe)
  end

  private

  def load_csv

    CSV.foreach(@csv_file_path) do |row|
      name = row[0]
      description = row[1]
      rating = row[2]
      preptime = row[3]
      done = row[4] == 'true'
      @recipes << Recipe.new(name, description, rating, preptime, done)
    end



  end

end
