module StoredLocation
  extend ActiveSupport::Concern

  SESSION_KEY = "user_return_to"

  EXCLUDED_CONTROLLERS = %w[signups sessions].freeze

  included do
    before_action :store_user_location, if: :storable_location?
  end

  def storable_location?
    request.get? &&
      EXCLUDED_CONTROLLERS.exclude?(controller_name) &&
      !request.xhr?
  end

  def store_user_location
    store_location(request.fullpath)
  end

  def store_location(location)
    session[stored_location_key] = location
  end

  def stored_location
    session[stored_location_key] || root_path
  end

  def after_log_in_path
    stored_location
  end

  def after_sign_up_path
    stored_location
  end

  private

  def stored_location_key
    SESSION_KEY
  end
end
