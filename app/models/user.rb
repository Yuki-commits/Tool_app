class User < ApplicationRecord
  has_secure_password

  validates :employee_number, presence: true, uniqueness: true
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :group_id, presence: true
  validates :admin, inclusion: { in: 0..3 }
  validates :password, length: { minimum: 6 }, on: :create
  validates :approval_flag, inclusion: { in: [true, false] }

  belongs_to :group
  has_many :tools
  has_many :tool_users

  def self.search(search_column, search_value)
    users = User
    return users = users.where("employee_number LIKE ?", "%#{search_value}%") if search_column == "employee_number"
    return users = users.where("name LIKE ?", "%#{search_value}%") if search_column == "name"
    return users = users.where("email LIKE ?", "%#{search_value}%") if search_column == "email"
  end

end
