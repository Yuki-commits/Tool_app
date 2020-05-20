class ToolUser < ApplicationRecord
  validates :tool_id, presence: true
  validates :user_id, presence: true
  validates :returned_flag, inclusion: { in: [true, false] }

  belongs_to :tool
  belongs_to :user

end
