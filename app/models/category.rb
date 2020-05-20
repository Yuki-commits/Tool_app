class Category < ApplicationRecord

  validates :name, presence: true, uniqueness: :ture

  has_many :tools, dependent: :restrict_with_error
  has_many :sub_categories, dependent: :restrict_with_error
  has_many :other_categories, dependent: :restrict_with_error

end
