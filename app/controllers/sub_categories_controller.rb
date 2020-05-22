class SubCategoriesController < ApplicationController
  before_action :logged_in_user
  before_action :set_categories, only:[:new, :create, :edit, :update, :destroy]
  before_action :set_target_sub_category, only:[:edit, :update, :destroy]
  before_action :ensure_app_admin_or_admin, only:[:new, :create, :edit, :update, :destroy]

  def new
    @sub_category = SubCategory.new
  end

  def edit
  end

  def create
    @sub_category = SubCategory.new(sub_category_params)
    if @sub_category.save
      flash[:success] = "登録しました"
      redirect_to categories_path
    else
      render :new
    end
  end

  def update
    if @sub_category.update(sub_category_params)
      flash[:success] = "更新しました"
      redirect_to categories_path
    else
      render :edit
    end
  end

  def destroy
    if @sub_category.destroy
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

  def sub_category_params
    params.require(:sub_category).permit(:name, :category_id)
  end

  def set_target_sub_category
    @sub_category = SubCategory.find_by(id: params[:id])
  end

end
