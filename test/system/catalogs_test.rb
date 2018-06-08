require "application_system_test_case"

class CatalogsTest < ApplicationSystemTestCase
  setup do
    @catalog = catalogs(:one)
  end

  test "visiting the index" do
    visit catalogs_url
    assert_selector "h1", text: "Catalogs"
  end

  test "creating a Catalog" do
    visit catalogs_url
    click_on "New Catalog"

    fill_in "Catalog Name", with: @catalog.catalog_name
    fill_in "Cpu Max", with: @catalog.cpu_max
    fill_in "Cpu Min", with: @catalog.cpu_min
    fill_in "Disk Size", with: @catalog.disk_size
    fill_in "Mem Max", with: @catalog.mem_max
    fill_in "Mem Min", with: @catalog.mem_min
    fill_in "Swap Disk", with: @catalog.swap_disk
    fill_in "Template Name", with: @catalog.template_name
    fill_in "Template Path", with: @catalog.template_path
    click_on "Create Catalog"

    assert_text "Catalog was successfully created"
    click_on "Back"
  end

  test "updating a Catalog" do
    visit catalogs_url
    click_on "Edit", match: :first

    fill_in "Catalog Name", with: @catalog.catalog_name
    fill_in "Cpu Max", with: @catalog.cpu_max
    fill_in "Cpu Min", with: @catalog.cpu_min
    fill_in "Disk Size", with: @catalog.disk_size
    fill_in "Mem Max", with: @catalog.mem_max
    fill_in "Mem Min", with: @catalog.mem_min
    fill_in "Swap Disk", with: @catalog.swap_disk
    fill_in "Template Name", with: @catalog.template_name
    fill_in "Template Path", with: @catalog.template_path
    click_on "Update Catalog"

    assert_text "Catalog was successfully updated"
    click_on "Back"
  end

  test "destroying a Catalog" do
    visit catalogs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Catalog was successfully destroyed"
  end
end
