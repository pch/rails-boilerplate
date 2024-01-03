class Users::Activity < ApplicationRecord
  has_based_uuid prefix: :uact

  belongs_to :user
  belongs_to :session, optional: true

  serialize :metadata, coder: JSON

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
