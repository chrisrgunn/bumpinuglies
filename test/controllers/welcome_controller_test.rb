require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get login" do
    get :login
    assert_response :success
  end

  test "should get signup" do
    get :signup
    assert_response :success
  end

  test "should get about" do
    get :about
    assert_response :success
  end

  test "should get features" do
    get :features
    assert_response :success
  end

  test "should get users" do
    get :users
    assert_response :success
  end

  test "should get profile" do
    get :profile
    assert_response :success
  end

  test "should get messages" do
    get :messages
    assert_response :success
  end

  test "should get events" do
    get :events
    assert_response :success
  end

end
