require 'test_helper'

class StandardBuildControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get standard_build_index_url
    assert_response :success
  end

  test "should get create" do
    get standard_build_create_url
    assert_response :success
  end

  test "should get find_datacenters" do
    get standard_build_find_datacenters_url
    assert_response :success
  end

  test "should get find_clusters" do
    get standard_build_find_clusters_url
    assert_response :success
  end

  test "should get find_datastores" do
    get standard_build_find_datastores_url
    assert_response :success
  end

  test "should get find_networks" do
    get standard_build_find_networks_url
    assert_response :success
  end

end
