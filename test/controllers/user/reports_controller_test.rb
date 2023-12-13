require "test_helper"

class User::ReportsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get user_reports_new_url
    assert_response :success
  end
end
