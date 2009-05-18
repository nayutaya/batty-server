
require 'test_helper'

class DevicesControllerTest < ActionController::TestCase
  def setup
    @yuya     = users(:yuya)
    @yuya_pda = devices(:yuya_pda)
  end

  test "routes" do
    base = {:controller => "devices"}

    assert_routing("/devices/new",    base.merge(:action => "new"))
    assert_routing("/devices/create", base.merge(:action => "create"))

    assert_routing("/device/0123456789", base.merge(:action => "show", :device_token => "0123456789"))
    assert_routing("/device/abcdef",     base.merge(:action => "show", :device_token => "abcdef"))
  end

  # TODO: newアクションのテストを実装せよ

  # TODO: createアクションのテストを実装せよ

  test "GET show" do
    session_login(@yuya)

    get :show, :device_token => @yuya_pda.device_token

    assert_response(:success)
    assert_template("show")
    assert_flash_empty
    assert_logged_in(@yuya)

    assert_equal(@yuya_pda, assigns(:device))
  end

  test "GET show, abnormal, no device token" do
    session_login(@yuya)

    get :show, :device_token => nil

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET show, abnormal, no login" do
    session_logout

    get :show, :device_token => @yuya_pda.device_token

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end
end
