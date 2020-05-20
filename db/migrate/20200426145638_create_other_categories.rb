class CreateOtherCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :other_categories do |t|
      t.string :name
      t.integer :sub_category_id

      t.timestamps
    end
  end
end
