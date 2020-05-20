class ChangeDatatypeAdminOfUsers < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :admin, :integer
  end
end
