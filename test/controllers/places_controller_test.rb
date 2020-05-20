require 'test_helper'

class PlacesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get places_index_url
    assert_response :success
  end

  test "should get new" do
    get places_new_url
    assert_response :success
  end

  test "should get edit" do
    get places_edit_url
    assert_response :success
  end

end
