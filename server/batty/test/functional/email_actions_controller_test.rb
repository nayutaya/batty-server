
require 'test_helper'

class EmailActionsControllerTest < ActionController::TestCase
  def setup
    @yuya          = users(:yuya)
    @yuya_pda      = devices(:yuya_pda)
    @yuya_pda_ge90 = triggers(:yuya_pda_ge90)

    @edit_form = EmailActionEditForm.new(
      :enable  => true,
      :email   => "email@example.jp",
      :subject => "subject",
      :body    => "body")

    session_login(@yuya)
  end

  test "routes" do
    base = {:controller => "email_actions"}

    assert_routing("/device/01234567/trigger/12345/acts/email/new",    base.merge(:action => "new", :device_token => "01234567", :trigger_id => "12345"))
    assert_routing("/device/89abcdef/trigger/67890/acts/email/new",    base.merge(:action => "new", :device_token => "89abcdef", :trigger_id => "67890"))
    assert_routing("/device/01234567/trigger/12345/acts/email/create", base.merge(:action => "create", :device_token => "01234567", :trigger_id => "12345"))
    assert_routing("/device/89abcdef/trigger/67890/acts/email/create", base.merge(:action => "create", :device_token => "89abcdef", :trigger_id => "67890"))
  end

  test "GET new" do
    get :new, :device_token => @yuya_pda.device_token, :trigger_id => @yuya_pda_ge90.id

    assert_response(:success)
    assert_template("new")
    assert_flash_empty
    assert_logged_in(@yuya)

    assert_equal(@yuya_pda, assigns(:device))
    assert_equal(@yuya_pda_ge90, assigns(:trigger))

    assert_equal(
      EmailActionEditForm.new.attributes,
      assigns(:edit_form).attributes)
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

  test "POST create" do
    assert_equal(true, @edit_form.valid?)

    assert_difference("EmailAction.count", +1) {
      post :create, :device_token => @yuya_pda.device_token, :trigger_id => @yuya_pda_ge90.id, :edit_form => @edit_form.attributes
    }

    assert_response(:redirect)
    assert_redirected_to(:controller => "devices", :action => "show", :device_token => @yuya_pda.device_token)
    assert_flash_notice
    assert_logged_in(@yuya)
  
    assert_equal(@yuya_pda, assigns(:device))
    assert_equal(@yuya_pda_ge90, assigns(:trigger))

    assert_equal(
      @edit_form.attributes,
      assigns(:edit_form).attributes)

    assert_equal(@yuya_pda_ge90.id,  assigns(:action).trigger_id)
    assert_equal(@edit_form.enable,  assigns(:action).enable)
    assert_equal(@edit_form.email,   assigns(:action).email)
    assert_equal(@edit_form.subject, assigns(:action).subject)
    assert_equal(@edit_form.body,    assigns(:action).body)
  end

  test "POST create, invalid form" do
    @edit_form.email = nil
    assert_equal(false, @edit_form.valid?)

    assert_difference("EmailAction.count", 0) {
      post :create, :device_token => @yuya_pda.device_token, :trigger_id => @yuya_pda_ge90.id, :edit_form => @edit_form.attributes
    }

    assert_response(:success)
    assert_template("new")
    assert_flash_error
  end

  test "POST create, abnormal, no login" do
    session_logout

    post :create

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST create, abnormal, no device token" do
    post :create, :device_token => nil

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST create, abnormal, no trigger id" do
    post :create, :device_token => @yuya_pda.device_token, :trigger_id => nil

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST create, abnormal, other's device" do
    # TODO: 実装せよ
  end

  test "POST create, abnormal, other's trigger" do
    # TODO: 実装せよ
  end

  test "GET create, abnormal, method not allowed" do
    # TODO: 実装せよ
  end
end
