module SetCurrentRequestDetails
  extend ActiveSupport::Concern

  included do
    before_action do
      Current.ip = request.remote_ip
      Current.user_agent = request.user_agent
      Current.referrer = request.referer
    end
  end
end
