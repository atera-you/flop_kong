require 'test_helper'

class SpanControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get span_new_url
    assert_response :success
  end

  test "should get create" do
    get span_create_url
    assert_response :success
  end

end
