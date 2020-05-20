class CreatePlaces < ActiveRecord::Migration[5.1]
  def change
    create_table :places do |t|
      t.integer :place_master_id

      t.timestamps
    end
  end
end
