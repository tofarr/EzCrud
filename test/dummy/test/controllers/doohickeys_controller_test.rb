require 'test_helper'

class DoohickeysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @doohickey = doohickeys(:one)
  end

  test "should get index" do
    get doohickeys_url
    assert_response :success
  end

  test "should get new" do
    get new_doohickey_url
    assert_response :success
  end

  test "should create doohickey" do
    assert_difference('Doohickey.count') do
      post doohickeys_url, params: { doohickey: { amount: @doohickey.amount, available: @doohickey.available, description: @doohickey.description, title: @doohickey.title, weight: @doohickey.weight } }
    end

    assert_redirected_to doohickey_url(Doohickey.last)
  end

  test "should show doohickey" do
    get doohickey_url(@doohickey)
    assert_response :success
  end

  test "should get edit" do
    get edit_doohickey_url(@doohickey)
    assert_response :success
  end

  test "should update doohickey" do
    patch doohickey_url(@doohickey), params: { doohickey: { amount: @doohickey.amount, available: @doohickey.available, description: @doohickey.description, title: @doohickey.title, weight: @doohickey.weight } }
    assert_redirected_to doohickey_url(@doohickey)
  end

  test "should destroy doohickey" do
    assert_difference('Doohickey.count', -1) do
      delete doohickey_url(@doohickey)
    end

    assert_redirected_to doohickeys_url
  end
end
