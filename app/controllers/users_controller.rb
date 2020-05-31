class UsersController < ApplicationController
  skip_before_action :logged_in_user, only:[:new, :create]
  before_action :forbid_login_user, only:[:new]
  before_action :set_target_user, only:[:destroy, :edit, :update, :approval]

  def new
    @user = User.new
    @groups = Group.all
    set_options_admin
  end

  def index
    set_options_admin
    return @users = current_user.group.users.page(params[:page]).per(10) unless app_admin?(current_user)
    @users = User.all.page(params[:page]).per(10)
  end

  def create
    @user = User.new(user_params)
    @user.approval_flag = false #デフォルトで承認待ちの状態に
    if @user.save
      log_in @user
      flash[:success] = "ユーザー登録が完了しました"
      redirect_to users_path
    else
      render :new
    end
  end

  def edit
    set_options_admin
    redirect_to users_path unless current_user_check(3)

    @groups = Group.all
    # 選択したユーザーが使用している工具一覧を取得
    @tools = Tool.joins(:tool_users).where(tool_users: { user_id: @user.id, returned_flag: false }).page(params[:page]).per(5)
    @button_text = "編集"

    # 各項目の編集権限の設定
    if viewer?(current_user) || !current_user.approval_flag
      @viewer_disabled = true unless current_user?(@user)
      @general_disabled = true
      @group_admin_boolean = true
    elsif general_user?(current_user)
      @viewer_disabled = true unless current_user?(@user)
      @general_disabled = true
      @group_admin_boolean = true
    end

    # 選択したユーザーがログイン中のユーザーかつアプリ管理者の場合は全部門の承認待ちユーザーを変数に格納
    if app_admin?(current_user) && current_user?(@user)
      @approval_pending_users = User.all.where(approval_flag: false) 
      return
    end

    # 選択したユーザーがログイン中のユーザーかつ管理者である場合、部門内承認待ちユーザーを変数に格納
    @current_admin = current_user?(@user) && admin?(@user)
    @current_admin = false unless current_user.approval_flag
    @approval_pending_users = @user.group.users.where(approval_flag: false) if @current_admin

  end

  def update
    if @user.update(user_params)
      flash[:success] = "ユーザー情報を更新しました"
      redirect_to users_path
    else
      render :edit
    end
  end

  # ユーザー登録申請されたユーザーに対しての承認処理
  def approval
    redirect_to users_path unless current_user_check(6)

    if @user
      @user.approval_flag = true
      @user.save
      flash[:success] = "承認しました"
    else
      flash[:danger] = "対象のユーザーが存在しません"
    end
    redirect_to edit_user_path(current_user.id)
  end

  # ユーザー登録申請されたユーザーに対しての否認処理
  def destroy
    if @user
      @user.destroy
      flash[:warning] = "対象のユーザーを否認、削除しました"
    else
      flash[:danger] = "対象のユーザーが存在しません"
    end
    redirect_to edit_user_path(current_user.id)
  end

  def search
    set_options_admin
    @search_column = params[:search_column]
    @search_value = params[:search_value]
    @users = User.search(@search_column, @search_value)
    @users = @users.where(group_id: current_user.group_id) unless app_admin?(current_user)
  end

  private
  def user_params
    params.require(:user).permit(:employee_number, :name, :email, :group_id, :admin, :password, :password_confirmation)
  end

  def set_target_user
    @user = User.find_by(id: params[:id])
  end

end
