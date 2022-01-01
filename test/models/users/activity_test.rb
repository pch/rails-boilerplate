require "test_helper"

module Users
  class ActivityTest < ActiveSupport::TestCase
    test "geocode new records" do
      activity = Users::Activity.new(user: User.system_user, action: "test", ip: "127.0.0.1")
      Users::GeocodeActivityJob.expects(:perform_later).with(activity)
      activity.save
    end
  end
end
