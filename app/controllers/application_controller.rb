class ApplicationController < ActionController::Base
  include SetCurrentRequestDetails
  include StoredLocation
end
