require "test_helper"

module Users
  class SessionsControllerTest < ActionDispatch::IntegrationTest
    test "should get new" do
      get new_users_session_url
      assert_response :success
    end

    test "should log in user" do
      user = create(:user)

      assert_difference("user.activities.count") do
        post users_sessions_url, params: { email: user.email, password: user.password }
      end

      assert_equal "login", user.activities.last.action

      assert_redirected_to root_url
      assert_logged_in_as user
    end

    test "should not log in user with invalid credentials" do
      user = create(:user)

      assert_difference("Users::Activity.count") do
        post users_sessions_url, params: { email: user.email, password: "invalid#{user.password}" }
      end

      assert_response :unprocessable_entity

      activity = User.guest_user.activities.last
      assert_equal "failed_login", activity.action
      assert_equal({ "email" => user.email }, activity.metadata)
    end

    test "should log out user" do
      user = create(:user)
      sign_in_as(user)

      assert_difference("user.activities.count") do
        delete logout_url
      end

      assert_redirected_to root_url
      assert_logged_out

      assert user.sessions.last.revoked?
      assert_equal "logout", user.activities.last.action
    end
  end
end
