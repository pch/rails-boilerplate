class Current < ActiveSupport::CurrentAttributes
  attribute :ip, :user_agent, :referrer
  attribute :user, :session
end
