class GroupsController < ApplicationController
  before_action :set_target_group, only:[:edit, :update, :destroy]

  def new
    redirect_to edit_group_path(id: current_user.group_id) unless current_user_check(5)
    @group = Group.new
  end

  def edit
    # アプリ管理者のみ編集可能
    unless app_admin?(current_user)
      @disabled = "disabled"
    end
  end

  def index
    redirect_to edit_group_path(id: current_user.group_id) unless current_user_check(5)
    @groups = Group.all
  end

  def create
    redirect_to edit_group_path(id: current_user.group_id) unless current_user_check(5)
    @group = Group.new(group_params)
    if @group.save
      flash[:success] = "登録しました"
      redirect_to groups_path
    else
      render :new
    end
  end

  def update
    redirect_to edit_group_path(id: current_user.group_id) unless current_user_check(5)
    if @group.update(group_params)
      flash[:success] = "更新しました"
      redirect_to groups_path
    else
      render :edit
    end

  end

  def destroy
    redirect_to edit_group_path(id: current_user.group_id) unless current_user_check(5)
    if @group.destroy
      flash[:success] = "削除しました"
      redirect_to groups_path
    else
      render :edit
    end
  end

  private
  def group_params
    params.require(:group).permit(:code, :name)
  end

  def set_target_group
    @group = Group.find_by(id: params[:id])
  end

end
