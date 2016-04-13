require 'test_helper'

class MessagingsControllerTest < ActionController::TestCase
  setup do
    @messaging = messagings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:messagings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create messaging" do
    assert_difference('Messaging.count') do
      post :create, messaging: { date: @messaging.date, message: @messaging.message, receiver: @messaging.receiver, sender: @messaging.sender }
    end

    assert_redirected_to messaging_path(assigns(:messaging))
  end

  test "should show messaging" do
    get :show, id: @messaging
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @messaging
    assert_response :success
  end

  test "should update messaging" do
    patch :update, id: @messaging, messaging: { date: @messaging.date, message: @messaging.message, receiver: @messaging.receiver, sender: @messaging.sender }
    assert_redirected_to messaging_path(assigns(:messaging))
  end

  test "should destroy messaging" do
    assert_difference('Messaging.count', -1) do
      delete :destroy, id: @messaging
    end

    assert_redirected_to messagings_path
  end
end
