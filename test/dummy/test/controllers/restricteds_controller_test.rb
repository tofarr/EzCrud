require 'test_helper'

class RestrictedsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @restricted = restricteds(:one)
  end

  test "should get index" do
    get restricteds_url
    assert_response :success
  end

  test "should get new" do
    get new_restricted_url
    assert_response :success
  end

  test "should create restricted" do
    assert_difference('Restricted.count') do
      post restricteds_url, params: { restricted: { only_owner_can_destroy: @restricted.only_owner_can_destroy, only_owner_can_edit: @restricted.only_owner_can_edit, only_owner_can_view: @restricted.only_owner_can_view, owner_id: @restricted.owner_id } }
    end

    assert_redirected_to restricted_url(Restricted.last)
  end

  test "should show restricted" do
    get restricted_url(@restricted)
    assert_response :success
  end

  test "should get edit" do
    get edit_restricted_url(@restricted)
    assert_response :success
  end

  test "should update restricted" do
    patch restricted_url(@restricted), params: { restricted: { only_owner_can_destroy: @restricted.only_owner_can_destroy, only_owner_can_edit: @restricted.only_owner_can_edit, only_owner_can_view: @restricted.only_owner_can_view, owner_id: @restricted.owner_id } }
    assert_redirected_to restricted_url(@restricted)
  end

  test "should destroy restricted" do
    assert_difference('Restricted.count', -1) do
      delete restricted_url(@restricted)
    end

    assert_redirected_to restricteds_url
  end
end
