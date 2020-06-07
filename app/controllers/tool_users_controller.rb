class ToolUsersController < ApplicationController

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

end
