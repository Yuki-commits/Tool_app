class AddIndex < ActiveRecord::Migration[5.1]
  def change
    add_index :users, [:employee_number, :email], unique: true
    add_index :tools, :code, unique: true
  end
end
