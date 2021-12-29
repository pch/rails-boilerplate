class Current < ActiveSupport::CurrentAttributes
  attribute :ip, :user_agent, :referrer
  attribute :user, :session

  def session=(session)
    super

    self.user = session&.user
  end
end
