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
  # 引数で受け取った数字の処理を実行し、処理不可の場合はメッセージと共にfalseを返す
  def current_user_check(check_pattern_number)
    check_result = true
    case check_pattern_number

    when 1  # アプリ管理者、部門管理者ユーザーである場合、trueを返す
      check_result = app_admin?(current_user) || admin?(current_user)

    when 2  # 閲覧権限のみのユーザー以外で、選択した工具の部門とログインユーザーの部門が一致する場合、trueを返す（アプリ管理者を除く）
      set_target_tool
      check_result = app_admin?(current_user) || @tool.group_id == current_user.group_id
      check_result = false if viewer?(current_user)

    when 3  # 選択したユーザーの部門とログインユーザーの部門が一致する場合、trueを返す（アプリ管理者を除く）
      set_target_user
      check_result = app_admin?(current_user) || @user.group_id == current_user.group_id

    when 4  # ユーザー区分が閲覧のみ以外のユーザーの場合、trueを返す
      check_result = !viewer?(current_user)

    when 5  # アプリ管理者の場合、trueを返す
      check_result = app_admin?(current_user)

    when 6  # ログイン中のユーザーが、選択されたユーザーと同一部門の管理者の場合、trueを返す（アプリ管理者は例外）
      set_target_user
      check_result = group_admin?(@user) || app_admin?(current_user)

    else
      check_result = true

    end

    flash[:danger] = "権限がありません" unless check_result
    check_result
  end

end
