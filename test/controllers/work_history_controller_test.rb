require 'test_helper'

class WorkHistoryControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get work_history_index_url
    assert_response :success
  end

end
