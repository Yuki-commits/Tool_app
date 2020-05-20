class UsersController < ApplicationController

  before_action :logged_in_user, only:[:index, :show, :edit, :update, :destroy, :approval, :search]
  before_action :forbid_login_user, only:[:new, :create]
  before_action :ensure_app_admin_or_same_group_current_user, only:[:edit, :update]
  before_action :ensure_group_admin, only:[:destroy, :approval]

  before_action :set_target_user, only:[:show, :edit, :update, :destroy, :approval]
  before_action :set_groups, only:[:new, :create, :show, :edit, :update]
  before_action :set_options_admin, only:[:new, :create, :show, :edit, :index, :search]
  before_action :gon_groups, only:[:new, :create, :edit]

  def index
    return @users = current_user.group.users.page(params[:page]).per(10) unless app_admin?(current_user)
    @users = User.all.page(params[:page]).per(10)
  end

  def new
    @user = User.new
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
    # 選択したユーザーが使用している工具一覧を取得
    @tools = Tool.joins(:tool_users).where(tool_users: { user_id: @user.id, returned_flag: false }).page(params[:page]).per(5)
    @button_text = "編集"

    if viewer?(current_user) || !current_user.approval_flag
      @viewer_disabled = true unless current_user?(@user)
      @general_disabled = true
      @group_admin_boolean = true
    elsif general_user?(current_user)
      @viewer_disabled = true unless current_user?(@user)
      @general_disabled = true
      @group_admin_boolean = true
    end

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
    @user.employee_number = user_params[:employee_number]
    @user.name = user_params[:name]
    @user.email = user_params[:email]
    @user.group_id = user_params[:group_id]
    @user.admin = user_params[:admin]
    if @user.save
      flash[:success] = "ユーザー情報を更新しました"
      redirect_to users_path
    else
      render :edit
    end
  end

  # ユーザー登録申請されたユーザーに対しての承認処理
  def approval
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

  # ログイン中のユーザーが、選択されたユーザーと同一部門の管理者ではない場合、ユーザー一覧にリダイレクト
  def ensure_group_admin
    return if app_admin?(current_user)
    set_target_user
    if !group_admin? @user
      flash[:danger] = "権限がありません"
      redirect_to users_path
    end
  end

  # ログイン中のユーザーが選択されたユーザーと同一部門、
  # もしくはアプリ管理者ではない場合、ユーザー一覧にリダイレクト
  def ensure_app_admin_or_same_group_current_user
    return if app_admin?(current_user)
    set_target_user
    unless @user.group_id == current_user.group_id
      flash[:danger] = "権限がありません"
      redirect_to users_path
    end
  end

end
