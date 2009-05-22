
require 'test_helper'

class HttpActionsControllerTest < ActionController::TestCase
  def setup
    @yuya          = users(:yuya)
    @yuya_pda      = devices(:yuya_pda)
    @yuya_pda_ge90 = triggers(:yuya_pda_ge90)

    session_login(@yuya)
  end

  test "routes" do
    base = {:controller => "http_actions"}

    assert_routing("/device/1234567890/trigger/2345678901/acts/http/new",    base.merge(:action => "new", :device_id => "1234567890", :trigger_id => "2345678901"))
    assert_routing("/device/1234567890/trigger/2345678901/acts/http/create", base.merge(:action => "create", :device_id => "1234567890", :trigger_id => "2345678901"))
  end

  test "GET new" do
    get :new, :device_id => @yuya_pda.id, :trigger_id => @yuya_pda_ge90.id

    assert_response(:success)
    assert_template("new")
    assert_flash_empty
    assert_logged_in(@yuya)

    assert_equal(@yuya_pda, assigns(:device))
    assert_equal(@yuya_pda_ge90, assigns(:trigger))

    assert_equal(
      HttpActionEditForm.new.attributes,
      assigns(:edit_form).attributes)
  end

  test "GET new, abnormal, no login" do
    session_logout

    get :new

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET new, abnormal, no device id" do
    get :new, :device_id => nil

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET new, abnormal, no trigger id" do
    get :new, :device_id => @yuya_pda.id, :trigger_id => nil

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET new, abnormal, other's device" do
    # TODO: 実装せよ
  end

  test "GET new, abnormal, other's trigger" do
    # TODO: 実装せよ
  end

  test "POST create" do
    # TODO: 実装せよ
  end

  test "POST create, invalid form" do
    # TODO: 実装せよ
  end

  test "GET create, abnormal, method not allowed" do
    # TODO: 実装せよ
  end

  test "POST create, abnormal, no login" do
    # TODO: 実装せよ
  end

  test "POST create, abnormal, no device id" do
    # TODO: 実装せよ
  end

  test "POST create, abnormal, no trigger id" do
    # TODO: 実装せよ
  end

  test "POST create, abnormal, other's device" do
    # TODO: 実装せよ
  end

  test "POST create, abnormal, other's trigger" do
    # TODO: 実装せよ
  end
end
