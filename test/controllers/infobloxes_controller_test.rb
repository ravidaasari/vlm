require 'test_helper'

class InfobloxesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @infoblox = infobloxes(:one)
  end

  test "should get index" do
    get infobloxes_url
    assert_response :success
  end

  test "should get new" do
    get new_infoblox_url
    assert_response :success
  end

  test "should create infoblox" do
    assert_difference('Infoblox.count') do
      post infobloxes_url, params: { infoblox: { encrypted_infoblox_password: @infoblox.encrypted_infoblox_password, encrypted_infoblox_password_iv: @infoblox.encrypted_infoblox_password_iv, infoblox_password: @infoblox.infoblox_password, infoblox_url: @infoblox.infoblox_url, infoblox_username: @infoblox.infoblox_username } }
    end

    assert_redirected_to infoblox_url(Infoblox.last)
  end

  test "should show infoblox" do
    get infoblox_url(@infoblox)
    assert_response :success
  end

  test "should get edit" do
    get edit_infoblox_url(@infoblox)
    assert_response :success
  end

  test "should update infoblox" do
    patch infoblox_url(@infoblox), params: { infoblox: { encrypted_infoblox_password: @infoblox.encrypted_infoblox_password, encrypted_infoblox_password_iv: @infoblox.encrypted_infoblox_password_iv, infoblox_password: @infoblox.infoblox_password, infoblox_url: @infoblox.infoblox_url, infoblox_username: @infoblox.infoblox_username } }
    assert_redirected_to infoblox_url(@infoblox)
  end

  test "should destroy infoblox" do
    assert_difference('Infoblox.count', -1) do
      delete infoblox_url(@infoblox)
    end

    assert_redirected_to infobloxes_url
  end
end
