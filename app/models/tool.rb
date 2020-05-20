class Tool < ApplicationRecord

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true
  validates :user_id, presence: true
  validates :group_id, presence: true
  validates :place_id, presence: true
  validates :category_id, presence: true

  belongs_to :user
  belongs_to :group
  belongs_to :place
  belongs_to :category
  belongs_to :sub_category, optional: true
  belongs_to :other_category, optional: true
  has_many :tool_users

  def self.search(search_column, search_value)
    tools = Tool
    return tools = tools.where("code LIKE ?", "%#{search_value}%") if search_column == "tool_code"
    return tools = tools.where("name LIKE ?", "%#{search_value}%") if search_column == "tool_name"
    return tools = tools.joins(:category).where("categories.name LIKE ?", "%#{search_value}%") if search_column == "category_name"
    return tools = tools.joins(place: :place_master).where("place_masters.building LIKE ?", "%#{search_value}%") if search_column == "place_building"
    return tools = tools.joins(place: :place_master).where("place_masters.room_num LIKE ?", "%#{search_value}%") if search_column == "place_room_num"
    return tools = tools.joins(place: :place_master).where("place_masters.name LIKE ?", "%#{search_value}%") if search_column == "place_name"
  end

end
