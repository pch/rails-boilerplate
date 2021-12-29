class Users::GeocodeActivityJob < ApplicationJob
  queue_as :geocoding

  def perform(activity)
    result = Geocoder.search(activity.ip).first
    return unless result

    activity.update!(
      country: result.try(:country),
      region: result.try(:state),
      city: result.try(:city)
    )
  rescue => e
    Rails.logger.warn "Geocoding failed: #{e.message}"
  end
end
