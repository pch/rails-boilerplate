require "test_helper"

module Users
  class EmailConfirmationsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = create(:user, email_confirmed_at: nil)
      sign_in_as(@user)
    end

    test "user should be forced to confirm email" do
      get root_url

      assert_redirected_to users_email_confirmations_url
    end

    test "should get index" do
      get users_email_confirmations_url

      assert_match I18n.t("users.email_confirmations.email_not_confirmed"), response.body
      assert_match "Resend confirmation link", response.body
      assert_match users_email_confirmations_path, response.body
    end

    test "should confirm email with valid token" do
      assert_difference("@user.activities.count") do
        get users_email_confirmation_url(id: @user.email_confirmation_token)
      end

      assert_redirected_to root_url

      @user.reload

      assert @user.email_confirmed?
      assert_equal "email_confirmed", @user.activities.last.action
      assert_equal I18n.t("users.email_confirmations.email_confirmed"), flash[:notice]
    end

    test "should not confirm email with invalid token" do
      assert_no_difference("@user.activities.count") do
        get users_email_confirmation_url(id: "invalid-token")
      end

      assert_redirected_to users_email_confirmations_url
      assert_equal I18n.t("users.email_confirmations.link_invalid_or_expired"), flash[:alert]
    end

    test "should resend confirmation link" do
      assert_difference("@user.activities.count") do
        post users_email_confirmations_url
      end

      assert_enqueued_emails 1
      assert_redirected_to users_email_confirmations_url
      assert_equal "email_confirmation_link_resent", @user.activities.last.action
      assert_equal I18n.t("users.email_confirmations.link_sent"), flash[:notice]
    end
  end
end
