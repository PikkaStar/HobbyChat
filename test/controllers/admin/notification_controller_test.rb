require "test_helper"

class Admin::NotificationControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_notification_index_url
    assert_response :success
  end
end
