require 'test_helper'

class PointOfInterestCommentsControllerTest < ActionController::TestCase
  setup do
    @point_of_interest_comment = point_of_interest_comments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:point_of_interest_comments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create point_of_interest_comment" do
    assert_difference('PointOfInterestComment.count') do
      post :create, :point_of_interest_comment => @point_of_interest_comment.attributes
    end

    assert_redirected_to point_of_interest_comment_path(assigns(:point_of_interest_comment))
  end

  test "should show point_of_interest_comment" do
    get :show, :id => @point_of_interest_comment.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @point_of_interest_comment.to_param
    assert_response :success
  end

  test "should update point_of_interest_comment" do
    put :update, :id => @point_of_interest_comment.to_param, :point_of_interest_comment => @point_of_interest_comment.attributes
    assert_redirected_to point_of_interest_comment_path(assigns(:point_of_interest_comment))
  end

  test "should destroy point_of_interest_comment" do
    assert_difference('PointOfInterestComment.count', -1) do
      delete :destroy, :id => @point_of_interest_comment.to_param
    end

    assert_redirected_to point_of_interest_comments_path
  end
end
