require 'test_helper'

class UserAuthenticationControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get user_authentication_index_url
    assert_response :success
  end

end
