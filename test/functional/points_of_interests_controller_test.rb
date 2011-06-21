require 'test_helper'

class PointsOfInterestsControllerTest < ActionController::TestCase
  setup do
    @points_of_interest = points_of_interests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:points_of_interests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create points_of_interest" do
    assert_difference('PointsOfInterest.count') do
      post :create, :points_of_interest => @points_of_interest.attributes
    end

    assert_redirected_to points_of_interest_path(assigns(:points_of_interest))
  end

  test "should show points_of_interest" do
    get :show, :id => @points_of_interest.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @points_of_interest.to_param
    assert_response :success
  end

  test "should update points_of_interest" do
    put :update, :id => @points_of_interest.to_param, :points_of_interest => @points_of_interest.attributes
    assert_redirected_to points_of_interest_path(assigns(:points_of_interest))
  end

  test "should destroy points_of_interest" do
    assert_difference('PointsOfInterest.count', -1) do
      delete :destroy, :id => @points_of_interest.to_param
    end

    assert_redirected_to points_of_interests_path
  end
end
