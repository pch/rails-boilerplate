# frozen_string_literal: true

class Current < ActiveSupport::CurrentAttributes
  attribute :ip, :user_agent, :referrer
end
