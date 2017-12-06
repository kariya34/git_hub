require 'test_helper'

class TimecardControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get timecard_index_url
    assert_response :success
  end

  test "should get showList" do
    get timecard_showList_url
    assert_response :success
  end

end
