class DropRecipes < ActiveRecord::Migration[7.1]
  def change
    drop_table :recipes do |t|
      t.string :name

      t.timestamps
    end
  end
end
