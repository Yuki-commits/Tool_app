class Place < ApplicationRecord

  validates :place_master_id, presence: true

  belongs_to :place_master
  has_many :tools, dependent: :restrict_with_exception

end
