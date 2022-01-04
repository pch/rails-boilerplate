module Authentication
  extend ActiveSupport::Concern

  SESSION_ACCESS_LOG_INTERVAL = 5.minutes

  included do
    before_action :authenticate_with_cookie
    before_action :log_session_access
    after_action :set_auth_token_cookie
  end

  private

  def authenticate_with_cookie
    session_token = cookies.encrypted[cookie_key]
    if session_token.present?
      Current.session = Users::Session.authenticate(session_token)
      Current.user = Current.session&.user
    end
    Current.user ||= User.guest_user
  end

  def log_session_access
    return if !Current.session || Current.session.accessed_at > SESSION_ACCESS_LOG_INTERVAL.ago

    Current.session.log_access
  end

  def set_auth_token_cookie
    return unless Current.session

    cookies.encrypted[cookie_key] = {
      value: Current.session.token,
      httponly: true,
      secure: Rails.env.production?,
      expires: Users::Session::SESSION_TTL,
      domain: :all
    }
  end

  def cookie_key
    :user_session
  end

  def require_authentication
    return true if Current.user.logged_in?

    redirect_to login_path, alert: t("users.auth.login_required")
  end

  def require_confirmed_email
    return true if !Current.user.logged_in? || Current.user.email_confirmed?

    redirect_to users_email_confirmations_path
  end

  def disallow_logged_in_user
    return true unless Current.user.logged_in?

    redirect_to root_path, alert: t("users.auth.already_logged_in")
  end

  def log_in(user)
    Current.session = Users::Session.create_new_session!(user)
    Current.user = user
    track_activity!(action: "login")
  end

  def log_out
    track_activity!(action: "logout")
    Current.session&.revoke!
    Current.session = nil
    Current.user = User.guest_user
    cookies.delete(cookie_key, domain: :all)
  end

  def track_activity!(action:, user: nil, session: nil, metadata: nil)
    Users::Activity.create!(
      user: user || Current.user,
      session: session || Current.session,
      action: action,
      metadata: metadata,
      ip: Current.ip,
      user_agent: Current.user_agent,
      referrer: Current.referrer
    )
  end
end
