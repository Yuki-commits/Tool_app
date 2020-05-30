module SessionsHelper

  # ログイン処理
  def log_in(user)
    session[:user_id] = user.id
  end

  # ログイン中のユーザーを返す
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  # 引数で受け取ったユーザーとログイン中のユーザーが一致した場合、trueを返す
  def current_user?(user)
    user == current_user
  end

  # ユーザーがログインしている場合、trueを返す
  def logged_in?
    !current_user.nil?
  end

  # ログアウト処理
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

end
