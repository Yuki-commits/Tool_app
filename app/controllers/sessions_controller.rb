class SessionsController < ApplicationController

  before_action :forbid_login_user, only:[:new, :create]
  before_action :logged_in_user, only:[:destroy]

  def new
    @user = User.new
  end

  def create
    employee_number_or_email = params[:employee_number_or_email]
    user = User.find_by(employee_number: employee_number_or_email)
    user = User.find_by(email: employee_number_or_email) unless user
    if user && user.authenticate(user_params[:password])
      log_in user
      flash[:success] = "おかえりなさい。#{user.name}さん。"
      redirect_to users_path
    else
      @error_massage = "社員番号・メールアドレスまたはパスワードが間違っています"
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
    params.require(:session).permit(:password)
  end

end
