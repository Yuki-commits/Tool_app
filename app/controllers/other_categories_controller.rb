class OtherCategoriesController < ApplicationController
  before_action :logged_in_user
  before_action :set_categories, only:[:new, :create, :edit, :update, :destroy]
  before_action :set_target_other_category, only:[:edit, :update, :destroy]
  before_action :ensure_app_admin_or_admin, only:[:new, :create, :edit, :update, :destroy]

  def edit
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
    if @other_category.destroy
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

  def other_category_params
    params.require(:other_category).permit(:name, :category_id)
  end

  def set_target_other_category
    @other_category = OtherCategory.find_by(id: params[:id])
  end

end
