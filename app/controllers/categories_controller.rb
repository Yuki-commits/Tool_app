class CategoriesController < ApplicationController
  before_action :logged_in_user
  before_action :set_categories, only:[:index]
  before_action :set_target_category, only:[:edit, :update, :destroy]
  before_action :ensure_app_admin_or_admin, only:[:new, :create, :edit, :update, :destroy]

  def index
  end

  def new
    @category = Category.new
  end

  def edit
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = "登録しました"
      redirect_to categories_path
    else
      render :new
    end
  end

  def update
    if @category.update(category_params)
      flash[:success] = "更新しました"
      redirect_to categories_path
    else
      render :edit
    end
  end

  def destroy
    if @category.destroy
      flash[:success] = "削除しました"
      redirect_to categories_path
    else
      render :edit
    end
  end

  private
  # アプリ管理者、管理者以外のユーザーをカテゴリー一覧ページにリダイレクト
  def ensure_app_admin_or_admin
    return if app_admin?(current_user)
    return if admin?(current_user)
    flash[:danger] = "権限がありません"
    redirect_to categories_path
  end

  def category_params
    params.require(:category).permit(:name)
  end

  def set_target_category
    @category = Category.find_by(id: params[:id])
  end

end
