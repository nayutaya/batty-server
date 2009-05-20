
require 'test_helper'

class EmailActionsControllerTest < ActionController::TestCase
  def setup
    @yuya          = users(:yuya)
    @yuya_pda      = devices(:yuya_pda)
    @yuya_pda_ge90 = triggers(:yuya_pda_ge90)

    session_login(@yuya)
  end

  test "routes" do
    base = {:controller => "email_actions"}

    assert_routing("/device/01234567/trigger/12345/acts/email/new", base.merge(:action => "new", :device_token => "01234567", :trigger_id => "12345"))
    assert_routing("/device/89abcdef/trigger/67890/acts/email/new", base.merge(:action => "new", :device_token => "89abcdef", :trigger_id => "67890"))
  end

  test "GET new" do
    get :new, :device_token => @yuya_pda.device_token, :trigger_id => @yuya_pda_ge90.id

    assert_response(:success)
    assert_template("new")
    assert_flash_empty
    assert_logged_in(@yuya)

    assert_equal(@yuya_pda, assigns(:device))
    assert_equal(@yuya_pda_ge90, assigns(:trigger))
  end

  test "GET new, abnormal, no login" do
    session_logout

    get :new

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET new, abnormal, no device token" do
    get :new, :device_token => nil

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET new, abnormal, no trigger" do
    get :new, :device_token => @yuya_pda.device_token, :trigger_id => nil

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
end
