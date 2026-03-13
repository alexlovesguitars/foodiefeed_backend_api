class UpdateRecipesTable < ActiveRecord::Migration[7.1]
  def change
    # Change text columns to jsonb
    remove_column :recipes, :ingredients, :text
    remove_column :recipes, :instructions, :text

    add_column :recipes, :ingredients, :jsonb, null: false, default: []
    add_column :recipes, :instructions, :jsonb, null: false, default: []

    # Add new columns
    add_column :recipes, :dietary_tags, :string, array: true, default: []
    add_column :recipes, :prep_time, :integer
    add_column :recipes, :cook_time, :integer
  end
end
