class SessionsController < ApplicationController

  before_action :forbid_login_user, only:[:new, :create]
  before_action :logged_in_user, only:[:destroy]

  def new
    @user = User.new
  end

  def create
    user = User.find_by(employee_number: user_params[:employee_number])
    if user && user.authenticate(user_params[:password])
      log_in user
      flash[:success] = "おかえりなさい。#{user.name}さん。"
      redirect_to users_path
    else
      @error_massage = "社員番号またはパスワードが間違っています"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    flash[:primary] = "ログアウトしました"
    redirect_to login_path
  end

  private
  def user_params
    params.require(:session).permit(:employee_number, :password)
  end

end
