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
  attr_accessor :id, :ingred_info, :name, :description, :ingredients, :instructions

  def initialize(id, name, description, ingredients=[], instructions)
    @id = id
    @name = name
    @description = description
    @ingredients = ingredients
    @instructions = instructions
  end

  def self.all
    @all_recipes = []
    Connect.connection do |connection|
      @recipe_list = connection.exec('SELECT name, id FROM recipes ORDER BY name')
    end
      @recipe_list.each do |recipe|
        recipe = Recipe.new(recipe["id"],recipe["name"], nil, nil, nil)
        @all_recipes << recipe
      end

  end

  def self.find(id)

    Connect.connection do |connection|
      @ingred_info = connection.exec_params('SELECT ingredients.name AS ingredients, recipes.name, recipes.description, recipes.instructions
        FROM ingredients FULL JOIN recipes ON recipes.id = ingredients.recipe_id
        WHERE ingredients.recipe_id = ($1)', [id])
    end
    @ingred_info

      @ingredients = []
      @ingred_info.each do |list|
        item = Recipe.new(nil,list["ingredients"], nil, nil, nil)
        @ingredients << item
      end

    descript = Recipe.new(@ingred_info[0]["id"],@ingred_info[0]["name"],@ingred_info[0]["description"], @ingredients, @ingred_info[0]["instructions"])
    #binding.pry
  end

 # def name
 #     name = Recipe.new(@ingred_info[0]["id"],@ingred_info[0]["name"])
 #     @name = name.name
 # end
    #  @description = @ingred_info[0]["name"]
    #  @instructions = @ingred_info[0]["instructions"]
     # binding.pry



end
