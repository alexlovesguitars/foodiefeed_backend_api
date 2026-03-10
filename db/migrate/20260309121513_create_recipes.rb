class CreateRecipes < ActiveRecord::Migration[7.1]
  def change
    create_table :recipes do |t|
      t.string :title, null: false
      t.text :description
      t.text :ingredients
      t.text :instructions
      t.boolean :public, default: false, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
