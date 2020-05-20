require 'test_helper'

class ToolsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get tools_index_url
    assert_response :success
  end

  test "should get new" do
    get tools_new_url
    assert_response :success
  end

  test "should get edit" do
    get tools_edit_url
    assert_response :success
  end

end
