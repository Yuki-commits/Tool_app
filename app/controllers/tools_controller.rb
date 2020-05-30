class ToolsController < ApplicationController

  def index
    @button_text = "編集"
    if app_admin?(current_user)
      @tools = Tool.all.page(params[:page]).per(10)
    else
      @tools = Tool.where(group_id: current_user.group_id).page(params[:page]).per(10)
      @button_text = "詳細" if viewer?(current_user)
    end

    respond_to do |format|
      format.html
      format.csv do
        export_time = l Time.new, format: :long2
        send_data render_to_string, filename: "tool_list_#{export_time}.csv", type: :csv
      end
    end
  end

  def new
    redirect_to tools_path unless current_user_check(4)
    @tool = Tool.new
    @categories = Category.all
    @places = Place.all
  end

  def create
    @categories = Category.all
    @places = Place.all
    @tool = Tool.new(tool_params)
    @tool.user_id = current_user.id
    @tool.group_id = current_user.group_id
    other_category_name = params[:other_category_name]

    # サブカテゴリーにてその他選択時、その他に入力がない場合エラー表示
    if other_category_name == ""
      @error_message = "「その他」を入力してください"
      render :new
      return
    end

    if other_category_name
      @other_category = OtherCategory.find_by(category_id: @tool.category_id, name: other_category_name)
      # 入力されたその他サブカテゴリーがDBに存在しない場合はDBに新規で登録
      unless @other_category
        @other_category = OtherCategory.new(category_id: @tool.category_id, name: other_category_name)
        return render :new unless @other_category.save
      end
      # 新規登録、又は既に登録済のその他サブカテゴリーを保存
      @tool.sub_category_id = 0
      @tool.other_category_id = @other_category.id
    end

    if @tool.save
      flash[:success] = "登録しました"
      redirect_to new_tool_path
    else
      render :new
    end
  end

  def update
    redirect_to tools_path unless current_user_check(2)
    @categories = Category.all
    @places = Place.all
    @tool.sub_category_id = tool_params[:sub_category_id]
    other_category_name = params[:other_category_name]

    # サブカテゴリーにてその他選択時、その他に入力がない場合エラー表示
    if @tool.sub_category_id == 0 && other_category_name == ""
      @error_message = "「その他」を入力してください"
      render :edit
      return
    end

    @tool.other_category_id = nil unless @tool.sub_category_id == 0

    if other_category_name
      @other_category = OtherCategory.find_by(category_id: @tool.category_id, name: other_category_name)
      # 入力されたその他サブカテゴリーがDBに存在しない場合はDBに新規で登録
      unless @other_category
        @other_category = OtherCategory.new(category_id: @tool.category_id, name: other_category_name)
        return render :new unless @other_category.save
      end
      # 新規登録、又は既に登録済のその他サブカテゴリーを保存
      @tool.other_category_id = @other_category.id
    end

    if @tool.update(tool_params)
      flash[:success] = "更新しました"
      redirect_to tools_path
    else
      render :edit
    end
  end

  def edit
    redirect_to tools_path unless current_user_check(2)
    @categories = Category.all
    @places = Place.all
    # その他カテゴリーが登録されている場合は、インスタンス変数に値を代入
    # 登録されていない場合は、その他サブカテゴリー入力欄を編集不可にする
    if @tool.other_category_id
      @other_category = @tool.other_category.name
    else
      @other_category_disabled = "disabled"
      @display_none = "d-none"
    end

    # ユーザー区分が閲覧者のユーザーは全て編集不可
    if viewer?(current_user)
      @disabled = "disabled"
      @other_category_disabled = "disabled"
    end
    @tool_user = ToolUser.find_by(tool_id: @tool.id, returned_flag: false)
  end

  def destroy
    redirect_to tools_path unless current_user_check(2)
    if ToolUser.find_by(tool_id: @tool.id, returned_flag: false)
      flash[:danger] = "使用中の工具は削除できません"
      redirect_to edit_tool_path @tool.id
      return
    end
    @tool.destroy
    flash[:success] = "削除しました"
    redirect_to tools_path
  end

  def search
    @search_column = params[:search_column]
    @search_value = params[:search_value]
    @tools = Tool.search(@search_column, @search_value)
    @tools = @tools.where(group_id: current_user.group_id) unless app_admin?(current_user)
    @tools = @tools.page(params[:page]).per(10)
    return @button_text = "詳細" if viewer?(current_user)
    @button_text = "編集"
  end

  private
  def tool_params
    params.require(:tool).permit(:code, :name, :quantity, :price, :place_id, :category_id, :sub_category_id)
  end

  def set_target_tool
    @tool = Tool.find_by(id: params[:id])
  end

end
