class RemovePhotosToTools < ActiveRecord::Migration[5.1]
  def change
    remove_column :tools, :photos, :string
  end
end
