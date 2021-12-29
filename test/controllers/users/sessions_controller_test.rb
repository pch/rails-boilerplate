require "test_helper"

module Users
  class SessionsControllerTest < ActionDispatch::IntegrationTest
    test "should get new" do
      get new_users_session_url
      assert_response :success
    end
  end
end
