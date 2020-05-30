class CategoriesController < ApplicationController
  before_action :set_target_category, only:[:edit, :update, :destroy]

  def index
    @categories = Category.all
  end

  def new
    redirect_to categories_path unless current_user_check(1)
    @category = Category.new
  end

  def edit
    redirect_to categories_path unless current_user_check(1)
  end

  def create
    redirect_to categories_path unless current_user_check(1)
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = "登録しました"
      redirect_to categories_path
    else
      render :new
    end
  end

  def update
    redirect_to categories_path unless current_user_check(1)
    if @category.update(category_params)
      flash[:success] = "更新しました"
      redirect_to categories_path
    else
      render :edit
    end
  end

  def destroy
    redirect_to categories_path unless current_user_check(1)
    if @category.destroy
      flash[:success] = "削除しました"
      redirect_to categories_path
    else
      render :edit
    end
  end

  private
  def category_params
    params.require(:category).permit(:name)
  end

  def set_target_category
    @category = Category.find_by(id: params[:id])
  end

end
