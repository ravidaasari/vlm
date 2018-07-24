require "application_system_test_case"

class InfobloxesTest < ApplicationSystemTestCase
  setup do
    @infoblox = infobloxes(:one)
  end

  test "visiting the index" do
    visit infobloxes_url
    assert_selector "h1", text: "Infobloxes"
  end

  test "creating a Infoblox" do
    visit infobloxes_url
    click_on "New Infoblox"

    fill_in "Encrypted Infoblox Password", with: @infoblox.encrypted_infoblox_password
    fill_in "Encrypted Infoblox Password Iv", with: @infoblox.encrypted_infoblox_password_iv
    fill_in "Infoblox Password", with: @infoblox.infoblox_password
    fill_in "Infoblox Url", with: @infoblox.infoblox_url
    fill_in "Infoblox Username", with: @infoblox.infoblox_username
    click_on "Create Infoblox"

    assert_text "Infoblox was successfully created"
    click_on "Back"
  end

  test "updating a Infoblox" do
    visit infobloxes_url
    click_on "Edit", match: :first

    fill_in "Encrypted Infoblox Password", with: @infoblox.encrypted_infoblox_password
    fill_in "Encrypted Infoblox Password Iv", with: @infoblox.encrypted_infoblox_password_iv
    fill_in "Infoblox Password", with: @infoblox.infoblox_password
    fill_in "Infoblox Url", with: @infoblox.infoblox_url
    fill_in "Infoblox Username", with: @infoblox.infoblox_username
    click_on "Update Infoblox"

    assert_text "Infoblox was successfully updated"
    click_on "Back"
  end

  test "destroying a Infoblox" do
    visit infobloxes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Infoblox was successfully destroyed"
  end
end
