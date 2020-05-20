class ChangeColumnToOtherCategory < ActiveRecord::Migration[5.1]
  def change
    rename_column :other_categories, :sub_category_id, :category_id
  end
end
