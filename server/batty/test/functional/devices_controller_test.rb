
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

  test "GET new" do
    session_login(@yuya)

    get :new

    assert_response(:success)
    assert_template("new")
    assert_flash_empty
    assert_logged_in(@yuya)

    assert_equal(
      DeviceEditForm.new.attributes,
      assigns(:edit_form).attributes)
  end

  test "GET new, abnormal, no login" do
    session_logout

    get :new

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  # TODO: createアクションのテストを実装せよ

  test "GET show" do
    session_login(@yuya)

    get :show, :device_token => @yuya_pda.device_token

    assert_response(:success)
    assert_template("show")
    assert_flash_empty
    assert_logged_in(@yuya)

    assert_equal(@yuya_pda, assigns(:device))
  
    assert_equal( 1, assigns(:energies).current_page)
    assert_equal(10, assigns(:energies).per_page)
    assert_equal(true, assigns(:energies).map(&:device).all? { |d| d == @yuya_pda })
    assert_equal(
      assigns(:energies).sort_by { |e| [e.observed_at, e.id] }.reverse,
      assigns(:energies))

    assert_equal( 1, assigns(:events).current_page)
    assert_equal(10, assigns(:events).per_page)
    assert_equal(true, assigns(:events).map(&:device).all? { |d| d == @yuya_pda })
    assert_equal(
      assigns(:events).sort_by { |e| [e.observed_at, e.id] }.reverse,
      assigns(:events))
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
