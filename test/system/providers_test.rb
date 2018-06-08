require "application_system_test_case"

class ProvidersTest < ApplicationSystemTestCase
  setup do
    @provider = providers(:one)
  end

  test "visiting the index" do
    visit providers_url
    assert_selector "h1", text: "Providers"
  end

  test "creating a Provider" do
    visit providers_url
    click_on "New Provider"

    fill_in "Provider Name", with: @provider.provider_name
    fill_in "Provider Password", with: @provider.provider_password
    fill_in "Provider Session", with: @provider.provider_session
    fill_in "Provider Type", with: @provider.provider_type
    fill_in "Provider Url", with: @provider.provider_url
    fill_in "Provider User", with: @provider.provider_user
    click_on "Create Provider"

    assert_text "Provider was successfully created"
    click_on "Back"
  end

  test "updating a Provider" do
    visit providers_url
    click_on "Edit", match: :first

    fill_in "Provider Name", with: @provider.provider_name
    fill_in "Provider Password", with: @provider.provider_password
    fill_in "Provider Session", with: @provider.provider_session
    fill_in "Provider Type", with: @provider.provider_type
    fill_in "Provider Url", with: @provider.provider_url
    fill_in "Provider User", with: @provider.provider_user
    click_on "Update Provider"

    assert_text "Provider was successfully updated"
    click_on "Back"
  end

  test "destroying a Provider" do
    visit providers_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Provider was successfully destroyed"
  end
end
