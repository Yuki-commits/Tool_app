module PlacesHelper

  def set_places
    @places = Place.all
  end

  def gon_place_Master
    # [id, id, ...]
    place_master_key = PlaceMaster.pluck(:id)
    # [[buiding, room_num, name], [buiding, room_num, name], ...]
    place_master_value = PlaceMaster.pluck(:building, :room_num, :name)
    # [[id, [buiding, room_num, name]], [id, [buiding, room_num, name]], ...]
    place_master = [place_master_key, place_master_value].transpose
    # { id => [buiding, room_num, name], id => [buiding, room_num, name], ...}
    gon.placeMaster = Hash[*place_master.flatten(1)]
  end

end
