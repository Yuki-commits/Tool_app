class GroupsController < ApplicationController
  before_action :logged_in_user
  before_action :ensure_app_admin, only:[:new, :index, :create, :update, :destroy]

  before_action :set_groups, only:[:index, :new, :edit, :destroy]
  before_action :set_target_group, only:[:edit, :update, :destroy]

  def new
    @group = Group.new
  end

  def edit
    # アプリ管理者のみ編集可能
    unless app_admin?(current_user)
      @disabled = "disabled"
    end
  end

  def index
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      flash[:success] = "登録しました"
      redirect_to groups_path
    else
      render :new
    end
  end

  def update
    @group.code = group_params[:code]
    @group.name = group_params[:name]
    if @group.save
      flash[:success] = "更新しました"
      redirect_to groups_path
    else
      render :edit
    end

  end

  def destroy
    if @group.destroy
      flash[:success] = "削除しました"
      redirect_to groups_path
    else
      render :edit
    end
  end

  private
  # アプリ管理者以外のユーザーをグループ編集ページにリダイレクト
  def ensure_app_admin
    return if app_admin?(current_user)
    flash[:danger] = "権限がありません"
    redirect_to edit_group_path(id: current_user.group_id)
  end

  def group_params
    params.require(:group).permit(:code, :name)
  end

  def set_target_group
    @group = Group.find_by(id: params[:id])
  end

end
