class OtherCategory < ApplicationRecord

  validates :name, presence: true, uniqueness: { scope: :category_id }
  validates :category_id, presence: true

  belongs_to :category
  has_many :tools, dependent: :restrict_with_error

end
