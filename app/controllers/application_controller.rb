class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :logged_in_user
  before_action :current_user_check
  before_action :gon_select_options

  include ApplicationHelper
  include SessionsHelper
  include UsersHelper

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
