module CategoriesHelper
  def set_categories
    @categories = Category.all
  end
end
