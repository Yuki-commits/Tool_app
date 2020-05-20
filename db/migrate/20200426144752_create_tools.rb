class CreateTools < ActiveRecord::Migration[5.1]
  def change
    create_table :tools do |t|
      t.string :code
      t.string :name
      t.integer :quantity
      t.integer :price
      t.string :photos
      t.integer :user_id
      t.integer :group_id
      t.integer :category_id
      t.integer :sub_category_id
      t.integer :other_category_id
      t.integer :place_id

      t.timestamps
    end
  end
end
