module OtherCategoriesHelper
  def gon_other_categories
    gon.otherCategories = OtherCategory.pluck(:name, :category_id)
  end
end
