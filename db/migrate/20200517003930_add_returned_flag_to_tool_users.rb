class AddReturnedFlagToToolUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :tool_users, :returned_flag, :boolean
  end
end
