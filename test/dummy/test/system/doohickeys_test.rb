require "application_system_test_case"

class DoohickeysTest < ApplicationSystemTestCase
  setup do
    @doohickey = doohickeys(:one)
  end

  test "visiting the index" do
    visit doohickeys_url
    assert_selector "h1", text: "Doohickeys"
  end

  test "creating a Doohickey" do
    visit doohickeys_url
    click_on "New Doohickey"

    fill_in "Amount", with: @doohickey.amount
    check "Available" if @doohickey.available
    fill_in "Description", with: @doohickey.description
    fill_in "Title", with: @doohickey.title
    fill_in "Weight", with: @doohickey.weight
    click_on "Create Doohickey"

    assert_text "Doohickey was successfully created"
    click_on "Back"
  end

  test "updating a Doohickey" do
    visit doohickeys_url
    click_on "Edit", match: :first

    fill_in "Amount", with: @doohickey.amount
    check "Available" if @doohickey.available
    fill_in "Description", with: @doohickey.description
    fill_in "Title", with: @doohickey.title
    fill_in "Weight", with: @doohickey.weight
    click_on "Update Doohickey"

    assert_text "Doohickey was successfully updated"
    click_on "Back"
  end

  test "destroying a Doohickey" do
    visit doohickeys_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Doohickey was successfully destroyed"
  end
end
