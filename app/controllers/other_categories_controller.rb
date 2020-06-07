class OtherCategoriesController < ApplicationController
  before_action :set_target_other_category, only:[:edit, :update, :destroy]

  def edit
    @categories = Category.all
  end

  def update
    if @other_category.update(other_category_params)
      Tool.where(other_category_id: @other_category.id).update_all(category_id: @other_category.category_id)
      flash[:success] = "更新しました"
      redirect_to categories_path
    else
      render :edit
    end
  end

  def destroy
    @categories = Category.all
    if @other_category.destroy
      flash[:success] = "削除しました"
      redirect_to categories_path
    else
      render :edit
    end
  end

  private
  def other_category_params
    params.require(:other_category).permit(:name, :category_id)
  end

  def set_target_other_category
    @other_category = OtherCategory.find_by(id: params[:id])
  end

end
