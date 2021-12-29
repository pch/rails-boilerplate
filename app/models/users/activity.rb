class Users::Activity < ApplicationRecord
  belongs_to :user
  belongs_to :session, optional: true

  serialize :metadata, JSON

  encrypts :ip, deterministic: true
  encrypts :metadata

  after_create :geocode

  def self.track!(action:, metadata: nil, user: nil)
    create! \
      user: user || Current.user,
      session: Current.session,
      action: action,
      metadata: metadata,
      ip: Current.ip,
      user_agent: Current.user_agent,
      referrer: Current.referrer
  end

  def geocode
    Users::GeocodeActivityJob.perform_later(self)
  end
end
