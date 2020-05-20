class PlaceMaster < ApplicationRecord

  validates :building, presence: true
  validates :room_num, presence: true
  validates :name, presence: true, uniqueness: { scope: [:building, :room_num]}
  has_one :place, dependent: :destroy

end
