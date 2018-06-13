require 'test_helper'

class CloneBuildControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get clone_build_index_url
    assert_response :success
  end

  test "should get find_datacenters" do
    get clone_build_find_datacenters_url
    assert_response :success
  end

  test "should get find_cdn" do
    get clone_build_find_cdn_url
    assert_response :success
  end

  test "should get create" do
    get clone_build_create_url
    assert_response :success
  end

end
