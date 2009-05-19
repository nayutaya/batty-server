
require 'test_helper'

class TriggersControllerTest < ActionController::TestCase
  def setup
    @yuya = users(:yuya)
    @yuya_pda = devices(:yuya_pda)

    @edit_form = TriggerEditForm.new(
      :enable   => true,
      :operator => Trigger.operator_symbol_to_code(:eq),
      :level    => 0)

    session_login(@yuya)
  end

  test "routes" do
    base = {:controller => "triggers"}

    assert_routing("/device/0123456789/triggers/new",    base.merge(:action => "new", :device_token => "0123456789"))
    assert_routing("/device/abcdef/triggers/new",        base.merge(:action => "new", :device_token => "abcdef"))
    assert_routing("/device/0123456789/triggers/create", base.merge(:action => "create", :device_token => "0123456789"))
    assert_routing("/device/abcdef/triggers/create",     base.merge(:action => "create", :device_token => "abcdef"))
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

  test "GET new, abnormal, other's device" do
    # TODO: 実装せよ
  end

  test "GET new, abnormal, no login" do
    session_logout

    get :new

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST create" do
    assert_equal(true, @edit_form.valid?)

    assert_difference("Trigger.count", +1) {
      post :create, :device_token => @yuya_pda.device_token, :edit_form => @edit_form.attributes
    }

    assert_response(:redirect)
    assert_redirected_to(:controller => "devices", :action => "show", :device_token => @yuya_pda.device_token)
    assert_flash_notice
    assert_logged_in(@yuya)

    assert_equal(@yuya_pda, assigns(:device))

    assert_equal(
      @edit_form.attributes,
      assigns(:edit_form).attributes)

    assert_equal(@yuya_pda.id,        assigns(:trigger).device_id)
    assert_equal(@edit_form.enable?,  assigns(:trigger).enable?)
    assert_equal(@edit_form.operator, assigns(:trigger).operator)
    assert_equal(@edit_form.level,    assigns(:trigger).level)
  end

  test "POST create, invalid form" do
    @edit_form.operator = nil
    assert_equal(false, @edit_form.valid?)

    assert_difference("Trigger.count", 0) {
      post :create, :device_token => @yuya_pda.device_token, :edit_form => @edit_form.attributes
    }

    assert_response(:success)
    assert_template("new")
    assert_flash_error
  end

  test "POST create, abnormal, no device token" do
    post :create, :device_token => nil

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST create, abnormal, other's device" do
    # TODO: 実装せよ
  end

  test "POST create, abnormal, no login" do
    session_logout

    post :create

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET create, abnormal, method not allowed" do
    get :create

    assert_response(405)
    assert_template(nil)
  end
end