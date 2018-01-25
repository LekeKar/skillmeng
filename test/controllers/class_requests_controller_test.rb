require 'test_helper'

class ClassRequestsControllerTest < ActionController::TestCase
  setup do
    @class_request = class_requests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:class_requests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create class_request" do
    assert_difference('ClassRequest.count') do
      post :create, class_request: { additional_info: @class_request.additional_info, classroom_id: @class_request.classroom_id, owner_read: @class_request.owner_read, sender_email: @class_request.sender_email, sender_name: @class_request.sender_name, sender_phone: @class_request.sender_phone, user_id: @class_request.user_id }
    end

    assert_redirected_to class_request_path(assigns(:class_request))
  end

  test "should show class_request" do
    get :show, id: @class_request
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @class_request
    assert_response :success
  end

  test "should update class_request" do
    patch :update, id: @class_request, class_request: { additional_info: @class_request.additional_info, classroom_id: @class_request.classroom_id, owner_read: @class_request.owner_read, sender_email: @class_request.sender_email, sender_name: @class_request.sender_name, sender_phone: @class_request.sender_phone, user_id: @class_request.user_id }
    assert_redirected_to class_request_path(assigns(:class_request))
  end

  test "should destroy class_request" do
    assert_difference('ClassRequest.count', -1) do
      delete :destroy, id: @class_request
    end

    assert_redirected_to class_requests_path
  end
end
