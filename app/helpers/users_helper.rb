module UsersHelper

  # ユーザー区分を配列としてインスタンス変数に格納し、View側にてeachメソッドで選択肢を表示
  def set_options_admin
    @options_admin_array = [[0, "一般（閲覧のみ）"], [1, "一般（一部編集可）"], [2, "部門管理者"], [3, "アプリ管理者"]]
    # 変数に格納した配列をハッシュに変換
    @options_admin_hash = Hash[*@options_admin_array.flatten]
  end

  # 引数で受け取った部門とログイン中のユーザーの部門が同一かつ、
  # ログイン中のユーザーが管理者の場合trueを返す
  def group_admin?(user)
    user.group_id == current_user.group_id && admin?(current_user)
  end

  # 引数で受け取ったユーザーの区分が閲覧のみのユーザー、
  # または未承認のユーザーの場合trueを返す
  def viewer?(user)
    return true unless user.approval_flag
    user.admin == 0
  end

  # 引数で受け取ったユーザーが一般ユーザーの場合trueを返す
  def general_user?(user)
    return false unless user.approval_flag
    user.admin == 1
  end

  # 引数で受け取ったユーザーが部門管理者の場合trueを返す
  def admin?(user)
    return false unless user.approval_flag
    user.admin == 2
  end

  # 引数で受け取ったユーザーがアプリ管理者の場合trueを返す
  def app_admin?(user)
    return false unless user.approval_flag
    user.admin == 3
  end

end
