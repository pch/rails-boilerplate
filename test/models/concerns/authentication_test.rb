require "test_helper"

module Users
  class AutheticationTest < ActiveSupport::TestCase
    test "email normalization" do
      assert_equal "john.doe@example.com", User.normalize_email("john.Doe@example.com")
      assert_equal "john.doe@example.com", User.normalize_email(" JOHN .DOE@example.com  ")

      email = " Foo@Example.com"
      user = create(:user, email: email)

      assert_equal "foo@example.com", user.email
    end

    test "#find_by_normalized_email" do
      user = create(:user)

      assert_equal user, User.find_by_normalized_email(user.email.upcase)
      assert_equal user, User.find_by_normalized_email(user.email.upcase)
      assert_nil User.find_by_normalized_email("invalid-email")
    end

    test "#authenticate_with_email_and_password" do
      user = create(:user)

      # correct credentials
      assert_equal user, User.authenticate_with_email_and_password(user.email, user.password)

      # correct credentials, non-normalized email
      assert_equal user, User.authenticate_with_email_and_password("   #{user.email.capitalize}", user.password)

      # non-existing email
      User.expects(:prevent_timing_attack)
      assert_nil User.authenticate_with_email_and_password("wrong@email", user.password)

      # wrong password
      assert_nil User.authenticate_with_email_and_password(user.email, "wrong-pass")

      # empty password
      User.expects(:prevent_timing_attack)
      assert_nil User.authenticate_with_email_and_password(user.email, "")
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

    test "terms acceptance" do
      user = build(:user, terms_accepted_at: nil)
      user.accept_terms = true
      user.save!

      assert user.terms_accepted_at.present?
    end

    test "default role" do
      user = build(:user, role: nil)
      user.save!

      assert_equal User::DEFAULT_ROLE, user.role
    end
  end
end
