class SubCategoriesController < ApplicationController
  before_action :set_target_sub_category, only:[:edit, :update, :destroy]

  def new
    redirect_to categories_path unless current_user_check(1)
    @categories = Category.all
    @sub_category = SubCategory.new
  end

  def edit
    redirect_to categories_path unless current_user_check(1)
    @categories = Category.all
  end

  def create
    redirect_to categories_path unless current_user_check(1)
    @categories = Category.all
    @sub_category = SubCategory.new(sub_category_params)
    if @sub_category.save
      flash[:success] = "登録しました"
      redirect_to categories_path
    else
      render :new
    end
  end

  def update
    redirect_to categories_path unless current_user_check(1)
    @categories = Category.all
    if @sub_category.update(sub_category_params)
      Tool.where(sub_category_id: @sub_category.id).update_all(category_id: @sub_category.category_id)
      flash[:success] = "更新しました"
      redirect_to categories_path
    else
      render :edit
    end
  end

  def destroy
    redirect_to categories_path unless current_user_check(1)
    @categories = Category.all
    if @sub_category.destroy
      flash[:success] = "削除しました"
      redirect_to categories_path
    else
      render :edit
    end
  end

  private
  def sub_category_params
    params.require(:sub_category).permit(:name, :category_id)
  end

  def set_target_sub_category
    @sub_category = SubCategory.find_by(id: params[:id])
  end

end
