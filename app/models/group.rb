class Group < ApplicationRecord

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true

  has_many :users, dependent: :restrict_with_error
  has_many :tools, dependent: :restrict_with_error

end
