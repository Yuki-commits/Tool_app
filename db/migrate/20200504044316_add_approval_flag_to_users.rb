class AddApprovalFlagToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :approval_flag, :boolean
  end
end
