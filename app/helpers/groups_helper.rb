module GroupsHelper

  def gon_groups
    # Groupモデルから配列を作成し変数に格納 = [[id, name], [id, name]]
    groups = Group.pluck(:id, :name)
    # 変数に格納した配列をハッシュに変換し、gon.変数名にてjavascriptに渡す = {id => name, id => name, ...}
    gon.groups = Hash[*groups.flatten]
  end

  def set_groups
    @groups = Group.all
  end

end
