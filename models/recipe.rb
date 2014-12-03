require 'pry'
require 'pg'

class Connect

  def self.connection
    begin
      connection = PG.connect(dbname: 'recipes')
      yield(connection)
    ensure
      connection.close
    end
  end
end

class Recipe
  attr_accessor :id

  def self.all

    Connect.connection do |connection|
      @recipe_list = connection.exec('SELECT name, id FROM recipes ORDER BY name')
    end
      @recipe_list.to_a
  end

  def self.find(id)

    Connect.connection do |connection|
      @ingred_info = connection.exec_params('SELECT ingredients.name AS ingredients, recipes.name, recipes.description, recipes.instructions
        FROM ingredients FULL JOIN recipes ON recipes.id = ingredients.recipe_id
        WHERE ingredients.recipe_id = ($1)', [id])
    end
      @ingred_info
  end

end
