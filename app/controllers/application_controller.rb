class ApplicationController < ActionController::Base
  include SetCurrentRequestDetails
  include Authentication
  include StoredLocation

  before_action :require_confirmed_email
end
