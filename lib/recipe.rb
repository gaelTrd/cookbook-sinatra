class Recipe
  attr_reader :name, :description, :rating, :preptime, :done

  def initialize(name, description, rating, preptime, done)
    @name = name
    @description = description
    @rating = rating
    @done = done
    @preptime = preptime
  end

  def done?
    @done
  end

  def mark_as_done!
    @done = true

  end
end
