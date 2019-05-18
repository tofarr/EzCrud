require "application_system_test_case"

class RestrictedsTest < ApplicationSystemTestCase
  setup do
    @restricted = restricteds(:one)
  end

  test "visiting the index" do
    visit restricteds_url
    assert_selector "h1", text: "Restricteds"
  end

  test "creating a Restricted" do
    visit restricteds_url
    click_on "New Restricted"

    check "Only owner can destroy" if @restricted.only_owner_can_destroy
    check "Only owner can edit" if @restricted.only_owner_can_edit
    check "Only owner can view" if @restricted.only_owner_can_view
    fill_in "Owner", with: @restricted.owner_id
    click_on "Create Restricted"

    assert_text "Restricted was successfully created"
    click_on "Back"
  end

  test "updating a Restricted" do
    visit restricteds_url
    click_on "Edit", match: :first

    check "Only owner can destroy" if @restricted.only_owner_can_destroy
    check "Only owner can edit" if @restricted.only_owner_can_edit
    check "Only owner can view" if @restricted.only_owner_can_view
    fill_in "Owner", with: @restricted.owner_id
    click_on "Update Restricted"

    assert_text "Restricted was successfully updated"
    click_on "Back"
  end

  test "destroying a Restricted" do
    visit restricteds_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Restricted was successfully destroyed"
  end
end
