class CreatePlaceMasters < ActiveRecord::Migration[5.1]
  def change
    create_table :place_masters do |t|
      t.string :building
      t.string :room_num
      t.string :name

      t.timestamps
    end
  end
end
