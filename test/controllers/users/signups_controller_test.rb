require "test_helper"

module Users
  class SignupsControllerTest < ActionDispatch::IntegrationTest
    test "should get new" do
      get new_users_signup_url
      assert_response :success
    end
  end
end
