require 'test_helper'

class CourseTeachersControllerTest < ActionController::TestCase
  setup do
    @course_teacher = course_teachers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:course_teachers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create course_teacher" do
    assert_difference('CourseTeacher.count') do
      post :create, course_teacher: { bio: @course_teacher.bio, name: @course_teacher.name, website: @course_teacher.website }
    end

    assert_redirected_to course_teacher_path(assigns(:course_teacher))
  end

  test "should show course_teacher" do
    get :show, id: @course_teacher
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @course_teacher
    assert_response :success
  end

  test "should update course_teacher" do
    patch :update, id: @course_teacher, course_teacher: { bio: @course_teacher.bio, name: @course_teacher.name, website: @course_teacher.website }
    assert_redirected_to course_teacher_path(assigns(:course_teacher))
  end

  test "should destroy course_teacher" do
    assert_difference('CourseTeacher.count', -1) do
      delete :destroy, id: @course_teacher
    end

    assert_redirected_to course_teachers_path
  end
end
