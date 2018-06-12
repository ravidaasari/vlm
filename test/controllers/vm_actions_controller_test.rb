require 'test_helper'

class VmActionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get vm_actions_index_url
    assert_response :success
  end

end
