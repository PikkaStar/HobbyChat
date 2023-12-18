require "test_helper"

class User::AreasControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get user_areas_show_url
    assert_response :success
  end
end
