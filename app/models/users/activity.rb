class Users::Activity < ApplicationRecord
  belongs_to :user
  belongs_to :session, optional: true

  serialize :metadata, JSON

  encrypts :ip, deterministic: true
  encrypts :metadata

  after_create :geocode

  def browser
    @browser ||= Browser.new(user_agent)
  end

  private

  def geocode
    Users::GeocodeActivityJob.perform_later(self)
  end
end
