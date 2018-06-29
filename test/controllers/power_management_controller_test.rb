require 'test_helper'

class PowerManagementControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get power_management_index_url
    assert_response :success
  end

end
