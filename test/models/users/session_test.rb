require "test_helper"

module Users
  class SessionTest < ActiveSupport::TestCase
    test "#create_new_session!" do
      assert_difference "Users::Session.count" do
        assert session.token.present?
        assert session.accessed_at.present?
      end
    end

    test "#authenticate" do
      assert_equal session, Users::Session.authenticate(session.token)
    end

    test "#log_access" do
      session.accessed_at = nil
      session.log_access
      assert session.accessed_at.present?
    end

    test "#revoke!" do
      session.revoked_at = nil
      session.revoke!
      assert session.revoked_at.present?
    end

    test "#revoked?" do
      session.revoked_at = nil
      assert !session.revoked?

      session.revoke!
      assert session.revoked?
    end

    private

    def session
      @session ||= Users::Session.create_new_session!(User.system_user.reload)
    end
  end
end
