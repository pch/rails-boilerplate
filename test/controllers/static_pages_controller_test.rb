require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get static_pages_show_url
    assert_response :success
  end
end
