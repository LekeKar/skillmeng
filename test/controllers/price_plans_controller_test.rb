require 'test_helper'

class CoursePlansControllerTest < ActionController::TestCase
  setup do
    @course_plan = course_plans(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:course_plans)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create course_plan" do
    assert_difference('CoursePlan.count') do
      post :create, course_plan: {  }
    end

    assert_redirected_to course_plan_path(assigns(:course_plan))
  end

  test "should show course_plan" do
    get :show, id: @course_plan
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @course_plan
    assert_response :success
  end

  test "should update course_plan" do
    patch :update, id: @course_plan, course_plan: {  }
    assert_redirected_to course_plan_path(assigns(:course_plan))
  end

  test "should destroy course_plan" do
    assert_difference('CoursePlan.count', -1) do
      delete :destroy, id: @course_plan
    end

    assert_redirected_to course_plans_path
  end
end
