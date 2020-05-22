class PlacesController < ApplicationController
  before_action :logged_in_user
  before_action :set_places, only:[:index]
  before_action :set_target_place, only:[:edit, :update, :destroy]
  before_action :ensure_app_admin_or_admin, only:[:new, :create, :edit, :update, :destroy]

  def index
  end

  def new
    @place_master = PlaceMaster.new
  end

  def create
    @place_master = PlaceMaster.new(place_master_params)
    return render :new unless @place_master.save
    place = Place.new(place_master_id: @place_master.id)
    if place.save
      flash[:success] = "登録しました"
      redirect_to places_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @place_master.update(place_master_params)
      flash[:success] = "更新しました"
      redirect_to places_path
    else
      render :new
    end
  end

  def destroy
    if @place_master.destroy
      flash[:success] = "削除しました"
      redirect_to places_path
    else
      render :edit
    end
  end

  private
  # アプリ管理者、管理者以外のユーザーをカテゴリー一覧ページにリダイレクト
  def ensure_app_admin_or_admin
    return if app_admin?(current_user)
    return if admin?(current_user)
    flash[:danger] = "権限がありません"
    redirect_to places_path
  end

  def place_master_params
    params.require(:place_master).permit(:building, :room_num, :name)
  end

  def set_target_place
    @place_master = PlaceMaster.find_by(id: params[:id])
  end

end
