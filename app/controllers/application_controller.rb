class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include UsersHelper
  include ToolsHelper
  include GroupsHelper
  include CategoriesHelper
  include SubCategoriesHelper
  include OtherCategoriesHelper
  include PlacesHelper

  private
  # ログインしていないユーザーをログインページにリダイレクト
  def logged_in_user
    unless logged_in?
      flash[:danger] = "ログインが必要です"
      redirect_to login_path
    end
  end

  # ログイン済のユーザーをユーザー一覧にリダイレクト
  def forbid_login_user
    if logged_in?
      flash[:danger] = "既にログインしています"
      redirect_to users_path
    end
  end

end
