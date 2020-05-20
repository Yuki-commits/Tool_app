module SubCategoriesHelper
  def gon_sub_categories
    gon.subCategories = SubCategory.pluck(:id, :name, :category_id)
  end
end
