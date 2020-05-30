class PlacesController < ApplicationController
  before_action :set_target_place, only:[:edit, :update, :destroy]

  def index
    @places = Place.all
  end

  def new
    redirect_to places_path unless current_user_check(1)
    @place_master = PlaceMaster.new
  end

  def create
    redirect_to places_path unless current_user_check(1)
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
    redirect_to places_path unless current_user_check(1)
  end

  def update
    redirect_to places_path unless current_user_check(1)
    if @place_master.update(place_master_params)
      flash[:success] = "更新しました"
      redirect_to places_path
    else
      render :new
    end
  end

  def destroy
    redirect_to places_path unless current_user_check(1)
    if @place_master.destroy
      flash[:success] = "削除しました"
      redirect_to places_path
    else
      render :edit
    end
  end

  private
  def place_master_params
    params.require(:place_master).permit(:building, :room_num, :name)
  end

  def set_target_place
    @place_master = PlaceMaster.find_by(id: params[:id])
  end

end
