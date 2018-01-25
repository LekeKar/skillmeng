require 'test_helper'

class GalleryPicsControllerTest < ActionController::TestCase
  setup do
    @gallery_pic = gallery_pics(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:gallery_pics)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create gallery_pic" do
    assert_difference('GalleryPic.count') do
      post :create, gallery_pic: { caption: @gallery_pic.caption }
    end

    assert_redirected_to gallery_pic_path(assigns(:gallery_pic))
  end

  test "should show gallery_pic" do
    get :show, id: @gallery_pic
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @gallery_pic
    assert_response :success
  end

  test "should update gallery_pic" do
    patch :update, id: @gallery_pic, gallery_pic: { caption: @gallery_pic.caption }
    assert_redirected_to gallery_pic_path(assigns(:gallery_pic))
  end

  test "should destroy gallery_pic" do
    assert_difference('GalleryPic.count', -1) do
      delete :destroy, id: @gallery_pic
    end

    assert_redirected_to gallery_pics_path
  end
end
