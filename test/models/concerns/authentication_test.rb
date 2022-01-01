require "test_helper"

module Users
  class AutheticationTest < ActiveSupport::TestCase
    test "#normalize_email" do
      assert_equal "john.doe@example.com", User.normalize_email("john.Doe@example.com")
      assert_equal "john.doe@example.com", User.normalize_email(" JOHN .DOE@example.com  ")
    end

    test "#find_by_normalized_email" do
      user = create(:user)

      assert_equal user, User.find_by_normalized_email(user.email.upcase)
      assert_equal user, User.find_by_normalized_email(user.email.upcase)
      assert_nil User.find_by_normalized_email("invalid-email")
    end

    test "#logged_in?" do
      assert build(:user).logged_in?
      assert !User.system_user.logged_in?
      assert !User.guest_user.logged_in?
    end

    test "email confirmation" do
      user = create(:user, email_confirmed_at: nil)
      assert !user.email_confirmed?

      user.confirm_email!
      assert user.email_confirmed?
      assert user.email_confirmed_at.present?
    end
  end
end
