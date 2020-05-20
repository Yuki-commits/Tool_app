require 'test_helper'

class OtherCategoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get other_categories_edit_url
    assert_response :success
  end

  test "should get new" do
    get other_categories_new_url
    assert_response :success
  end

end
