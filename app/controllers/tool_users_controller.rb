class ToolUsersController < ApplicationController

  before_action :logged_in_user
  before_action :ensure_tool_group_same_current_user_group
  before_action :ensure_not_viewer

  def create
    tool_user = current_user.tool_users.new(tool_id: params[:tool_id], returned_flag: false)
    tool_user.save
    flash[:success] = "#{tool_user.tool.code}を使用中に変更しました"
    redirect_to tools_path
  end

  def update
    tool_user = ToolUser.find_by(tool_id: params[:tool_id], returned_flag: false)
    tool_user.returned_flag = true
    tool_user.save
    flash[:success] = "#{tool_user.tool.code}を返却済に変更しました"
    redirect_to tools_path
  end

  private
  # 選択した工具の管理部門とログイン中のユーザーの部門が一致しない場合は一覧ページにリダイレクト
  # アプリ管理者を除く
  def ensure_tool_group_same_current_user_group
    tool = Tool.find_by(id: params[:tool_id])
    return if app_admin?(current_user)
    return if tool.group_id == current_user.group_id
    flash[:danger] = "権限がありません"
    redirect_to tools_path
  end

  # ユーザー区分が閲覧のみのユーザーを工具一覧ページにリダイレクト
  def ensure_not_viewer
    return unless viewer?(current_user)
    flash[:danger] = "権限がありません"
    redirect_to tools_path
  end

end
