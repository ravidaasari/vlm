require 'test_helper'

class DecommissionControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get decommission_index_url
    assert_response :success
  end

end
