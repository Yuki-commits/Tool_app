class GroupsController < ApplicationController
  before_action :set_target_group, only:[:edit, :update, :destroy]

  def new
    @group = Group.new
  end

  def edit
    # アプリ管理者のみ編集可能
    @disabled = "disabled" unless app_admin?(current_user)
  end

  def index
    @groups = Group.all
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
    if @group.update(group_params)
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
  def group_params
    params.require(:group).permit(:code, :name)
  end

  def set_target_group
    @group = Group.find_by(id: params[:id])
  end

end
