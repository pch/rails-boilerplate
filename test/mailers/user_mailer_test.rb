require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  setup do
    @user = create(:user)
  end

  test "email_confirmation" do
    mail = UserMailer.with(user: @user).email_confirmation
    assert_equal "Confirm your email", mail.subject
    assert_equal [@user.email], mail.to
    assert_equal [Rails.configuration.app.fetch(:mailer).fetch(:default_from)], mail.from
    assert_match "Click the link below to confirm your email address", mail.body.encoded
  end

  test "forgot_password" do
    mail = UserMailer.with(user: @user).forgot_password
    assert_equal "Reset your password", mail.subject
    assert_equal [@user.email], mail.to
    assert_equal [Rails.configuration.app.fetch(:mailer).fetch(:default_from)], mail.from
    assert_match "Click the link below to change your account password", mail.body.encoded
  end
end
