require "test_helper"

module Users
  class SignupsControllerTest < ActionDispatch::IntegrationTest
    test "should get new" do
      get new_users_signup_url
      assert_response :success
    end

    test "should create user" do
      user = build(:user)

      user_params = {
        name: user.name,
        email: user.email,
        password: user.password,
        password_confirmation: user.password,
        accept_terms: "1"
      }

      assert_difference("User.count") do
        post users_signups_url, params: { user: user_params }
      end

      assert_redirected_to root_url

      user = User.find_by_email!(user.email)
      user.confirm_email!
      assert_equal %w[signup login], user.activities.pluck(:action)

      assert_logged_in_as user
    end

    test "should not create user with invalid params" do
      user_params = {
        name: "John Doe",
        email: "john",
        password: "password"
      }

      assert_no_difference("User.count") do
        post users_signups_url, params: { user: user_params }
      end

      assert_response :unprocessable_entity
    end
  end
end
