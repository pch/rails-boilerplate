class Current < ActiveSupport::CurrentAttributes
  attribute :ip, :user_agent, :referrer
end
