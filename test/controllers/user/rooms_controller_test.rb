require "test_helper"

class User::RoomsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get user_rooms_show_url
    assert_response :success
  end
end
