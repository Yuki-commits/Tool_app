require 'csv'
require 'nkf'

csv_str = CSV.generate do |csv|
  csv_column_names = [
    Tool.human_attribute_name(:code),
    Tool.human_attribute_name(:name),
    Category.human_attribute_name(:name),
    SubCategory.human_attribute_name(:name),
    OtherCategory.human_attribute_name(:name),
    PlaceMaster.human_attribute_name(:building),
    PlaceMaster.human_attribute_name(:room_num),
    PlaceMaster.human_attribute_name(:name),
    ToolUser.human_attribute_name(:user_id),
    Tool.human_attribute_name(:created_at)
  ]
  csv << csv_column_names
  @tools.each do |tool|
    tool_user = ToolUser.find_by(tool_id: tool.id)
    sub_category_name = tool.sub_category.name if tool.sub_category
    other_category_name = tool.other_category.name if tool.other_category
    tool_user_employee_number = tool_user.user.employee_number if tool_user
  
    csv_column_values = [
      tool.code,
      tool.name,
      tool.category.name,
      sub_category_name,
      other_category_name,
      tool.place.place_master.building,
      tool.place.place_master.room_num,
      tool.place.place_master.name,
      tool_user_employee_number,
      tool.created_at.strftime("%Y/%-m/%-d %H:%M:%S")
    ]

    csv << csv_column_values

  end
end

NKF::nkf('--sjis -Lw', csv_str)
