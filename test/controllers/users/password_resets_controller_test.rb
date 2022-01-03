require "test_helper"

module Users
  class PasswordResetsControllerTest < ActionDispatch::IntegrationTest
    test "should get new" do
      get new_users_password_reset_url
      assert_response :success
    end

    test "should send reset link when user exists" do
      user = create(:user)

      assert_difference("user.activities.count") do
        post users_password_resets_url, params: { email: user.email }
      end

      assert_redirected_to new_users_password_reset_url(sent: true)
      assert_enqueued_emails 1
      assert_equal "password_reset_requested", user.activities.last.action
    end

    test "should store reset attempt for invalid email" do
      assert_difference("Users::Activity.count") do
        post users_password_resets_url, params: { email: "wrong-email" }
      end

      assert_redirected_to new_users_password_reset_url(sent: true)
      assert_enqueued_emails 0
      assert_equal "password_reset_requested", User.guest_user.activities.last.action
    end

    test "should show password reset form when token is valid" do
      user = create(:user)
      get edit_users_password_reset_url(id: user.password_reset_token)
      assert_response :success
    end

    test "should not show password reset form when token is invalid" do
      get edit_users_password_reset_url(id: "invalid_token")

      assert_redirected_to new_users_password_reset_url
      assert_equal I18n.t("users.password_resets.invalid_or_expired_link"), flash[:alert]
    end

    test "should set a new password" do
      user = create(:user)
      new_pass = SecureRandom.hex

      assert_difference("user.activities.count") do
        patch users_password_reset_url(id: user.password_reset_token), params: { user: { password: new_pass, password_confirmation: new_pass } }
      end

      assert_redirected_to root_url
      assert_equal I18n.t("users.password_resets.password_was_reset"), flash[:notice]
      assert_equal "password_reset", user.activities.last.action
    end

    test "should not set a new password when token is invalid" do
      new_pass = SecureRandom.hex

      assert_no_difference("Users::Activity.count") do
        patch users_password_reset_url(id: "invalid-token"), params: { user: { password: new_pass, password_confirmation: new_pass } }
      end

      assert_redirected_to new_users_password_reset_url
      assert_equal I18n.t("users.password_resets.invalid_or_expired_link"), flash[:alert]
    end

    test "should not set a new password when input is invalid" do
      user = create(:user)
      new_pass = SecureRandom.hex

      assert_no_difference("Users::Activity.count") do
        patch users_password_reset_url(id: user.password_reset_token), params: { user: { password: new_pass, password_confirmation: "not correct" } }
      end

      assert_response :unprocessable_entity
    end
  end
end
