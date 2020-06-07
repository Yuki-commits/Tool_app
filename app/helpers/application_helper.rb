module ApplicationHelper

  # 各種テーブルの値を取得し、「gon.*」にてjavascriptに渡す
  def gon_select_options
    # Groupモデルから配列として取得、ハッシュに変換
    # [[id, name], [id, name], ...] -> {id => name, id => name, ...}
    gon.groups = Hash[*Group.pluck(:id, :name).flatten]

    gon.subCategories = SubCategory.pluck(:id, :name, :category_id)
    gon.otherCategories = OtherCategory.pluck(:name, :category_id)

    # [id, id, ...]
    place_master_key = PlaceMaster.pluck(:id)
    # [[buiding, room_num, name], [buiding, room_num, name], ...]
    place_master_value = PlaceMaster.pluck(:building, :room_num, :name)
    # [[id, [buiding, room_num, name]], [id, [buiding, room_num, name]], ...]
    place_master = [place_master_key, place_master_value].transpose
    # { id => [buiding, room_num, name], id => [buiding, room_num, name], ...}
    gon.placeMaster = Hash[*place_master.flatten(1)]
  end


  # ログイン中のユーザーが処理が可能なユーザーかどうかの判定を行う
  # ユーザー区分によって権限を規制し、処理不可の場合はメッセージと共にtrueを返す
  def current_user_check
    return unless logged_in?

    # 規制をかけるコントローラーとアクションをセット
    # 条件とユーザー区分によって規制を緩和していく
    not_executable_action = {
      CategoriesController        => %w[new create edit update destroy],
      GroupsController            => %w[new create edit update destroy],
      OtherCategoriesController   => %w[edit update destroy],
      PlacesController            => %w[new create edit update destroy],
      SubCategoriesController     => %w[new create edit update destroy],
      ToolsController             => %w[new create edit update destroy],
      ToolUsersController         => %w[create update],
      UsersController             => %w[edit update destroy, approval]
    }

    tool_group_match, user_group_match = false, false
    case request.controller_class.name
    when ToolsController.name
      set_target_tool
      # ログインユーザーと選択した工具の部門が一致するかどうかを変数に格納
      tool_group_match = current_user.group == @tool.group if @tool
      not_executable_action[ToolsController].delete("edit") if tool_group_match

    when UsersController.name
      set_target_user
      # ログインユーザーと選択したユーザーの部門が一致するかどうかを変数に格納
      user_group_match = current_user.group == @user.group if @user
      not_executable_action[UsersController].delete("edit") if user_group_match

      # ログインユーザーの更新処理は許可
      not_executable_action[UsersController].delete("update") if current_user_match = current_user?(@user)

    when GroupsController.name
      set_target_group
      # ログインユーザーの部門と選択した部門が一致する場合、editを許可
      not_executable_action[GroupsController].delete("edit") if current_user.group == @group

    end

    # ユーザー区分によって処理を許可するアクションを分ける
    current_user_admin = current_user.admin                       # ユーザー区分を変数に格納
    current_user_admin = 0 unless current_user.approval_flag      # 未承認のユーザーは、閲覧と同一の権限にする

    # 「一般（一部編集可）」以上のユーザー
    if current_user_admin >= 1
      # ログインユーザーと同一部門の工具に関しては処理を許可
      if tool_group_match
        not_executable_action.delete(ToolsController)
      else
        # newとcreateは閲覧者以上であれば実行可能に
        not_executable_action[ToolsController] -= %w[new create]
      end

      not_executable_action.delete(ToolUsersController)
    end

    # 「部門管理者」以上のユーザー
    if current_user_admin >= 2
      # ログインユーザーと同一部門のユーザーに関しては処理を許可
      not_executable_action.delete(UsersController) if user_group_match
      # 以下のコントローラのアクションを許可
      not_executable_action.delete(CategoriesController)
      not_executable_action.delete(OtherCategoriesController)
      not_executable_action.delete(PlacesController)
      not_executable_action.delete(SubCategoriesController)
    end

    # 「アプリ管理者」は、全てのアクションを許可
    not_executable_action = {} if current_user_admin >= 3

    # リクエストされたコントローラー、アクションを取得
    request_controller = request.controller_class
    request_action = params[:action]

    # リクエストされたコントローラーが実行不可リストに存在するか確認し、
    # 存在していた場合、リクエストされたアクションが存在するかを確認する
    find_controller = not_executable_action[request_controller]
    find_action = find_controller.include?(request_action) if find_controller

    if find_action
      flash[:danger] = "権限がありません"
      redirect_to users_path
    end
  end

end
