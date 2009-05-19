
require 'test_helper'

class TriggersControllerTest < ActionController::TestCase
  def setup
    @yuya = users(:yuya)
    @yuya_pda = devices(:yuya_pda)

    @edit_form = TriggerEditForm.new

    session_login(@yuya)
  end

  test "routes" do
    base = {:controller => "triggers"}

    assert_routing("/device/0123456789/triggers/new", base.merge(:action => "new", :device_token => "0123456789"))
    assert_routing("/device/abcdef/triggers/new",     base.merge(:action => "new", :device_token => "abcdef"))
  end

  test "GET new" do
    get :new, :device_token => @yuya_pda.device_token

    assert_response(:success)
    assert_template("new")
    assert_flash_empty
    assert_logged_in(@yuya)

    assert_equal(@yuya_pda, assigns(:device))

    assert_equal(
      TriggerEditForm.new.attributes,
      assigns(:edit_form).attributes)

    assert_equal(
      TriggerEditForm.operators_for_select(:include_blank => true),
      assigns(:operators_for_select))
  end

  test "GET new, abnormal, no device token" do
    get :new, :device_token => nil

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET new, abnormal, no login" do
    session_logout

    get :new

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end
end
