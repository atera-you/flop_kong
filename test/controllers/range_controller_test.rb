require 'test_helper'

class RangeControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get range_new_url
    assert_response :success
  end

  test "should get create" do
    get range_create_url
    assert_response :success
  end

end
