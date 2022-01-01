require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get terms" do
    get terms_url
    assert_response :success
  end

  test "should get privacy policy" do
    get privacy_policy_url
    assert_response :success
  end
end
