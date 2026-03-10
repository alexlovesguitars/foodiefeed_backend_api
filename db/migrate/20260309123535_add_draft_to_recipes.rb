class AddDraftToRecipes < ActiveRecord::Migration[7.1]
  def change
    add_column :recipes, :draft, :boolean, default: false, null: false
  end
end
