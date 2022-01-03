ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/unit"
require "mocha/minitest"

User.guest_user # force guest user creation
User.system_user # force system user creation

module ActiveSupport
  class TestCase
    include FactoryBot::Syntax::Methods

    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...

    def sign_in_as(user)
      post users_sessions_url, params: { email: user.email, password: user.password }
    end

    def assert_logged_in_as(user)
      get root_url
      assert_match logout_path, response.body
    end

    def assert_logged_out
      get root_url
      assert_match login_path, response.body
    end
  end
end
