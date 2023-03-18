require 'test_helper'

class KongControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get kong_home_url
    assert_response :success
  end

end
