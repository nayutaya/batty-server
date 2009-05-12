
require 'test_helper'

class AuthControllerTest < ActionController::TestCase
  test "routes" do
    # TODO: 実装せよ
  end

  test "GET login_complete" do
    return_path = "/return"

    get :login_complete, :return_path => return_path

    assert_response(:success)
    assert_template("login_complete")

    assert_equal(return_path, assigns(:return_path))
  end

  test "GET login_complete, without return path" do
    get :login_complete

    assert_response(:success)
    assert_template("login_complete")

    assert_equal(root_path, assigns(:return_path))
  end
end
