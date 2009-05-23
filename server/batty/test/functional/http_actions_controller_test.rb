
require 'test_helper'

class HttpActionsControllerTest < ActionController::TestCase
  def setup
    @yuya          = users(:yuya)
    @yuya_pda      = devices(:yuya_pda)
    @shinya_note   = devices(:shinya_note)
    @yuya_pda_ge90 = triggers(:yuya_pda_ge90)

    @edit_form = HttpActionEditForm.new(
      :enable      => true,
      :http_method => "GET",
      :url         => "http://example.jp/")

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
    get :new, :device_id => @shinya_note.id, :trigger_id => @yuya_pda_ge90.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET new, abnormal, other's trigger" do
    # TODO: 実装せよ
  end

  test "POST create" do
    assert_equal(true, @edit_form.valid?)

    assert_difference("HttpAction.count", +1) {
      post :create, :device_id => @yuya_pda.id, :trigger_id => @yuya_pda_ge90.id, :edit_form => @edit_form.attributes
    }

    assert_response(:redirect)
    assert_redirected_to(:controller => "devices", :action => "show", :device_id => @yuya_pda.id)
    assert_flash_notice
    assert_logged_in(@yuya)

    assert_equal(@yuya_pda, assigns(:device))
    assert_equal(@yuya_pda_ge90, assigns(:trigger))

    assert_equal(
      @edit_form.attributes,
      assigns(:edit_form).attributes)

    assert_equal(@yuya_pda_ge90.id,      assigns(:action).trigger_id)
    assert_equal(@edit_form.enable,      assigns(:action).enable)
    assert_equal(@edit_form.http_method, assigns(:action).http_method)
    assert_equal(@edit_form.url,         assigns(:action).url)
    assert_equal(@edit_form.body,        assigns(:action).body)
  end

  test "POST create, invalid form" do
    @edit_form.http_method = nil
    assert_equal(false, @edit_form.valid?)

    assert_difference("HttpAction.count", 0) {
      post :create, :device_id => @yuya_pda.id, :trigger_id => @yuya_pda_ge90.id, :edit_form => @edit_form.attributes
    }

    assert_response(:success)
    assert_template("new")
    assert_flash_error
  end

  test "GET create, abnormal, method not allowed" do
    get :create

    assert_response(405)
    assert_template(nil)
  end

  test "POST create, abnormal, no login" do
    session_logout

    post :create

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST create, abnormal, no device id" do
    post :create, :device_id => nil

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST create, abnormal, no trigger id" do
    post :create, :device_id => @yuya_pda.id, :trigger_id => nil

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST create, abnormal, other's device" do
    post :create, :device_id => @shinya_note.id, :trigger_id => @yuya_pda_ge90.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST create, abnormal, other's trigger" do
    # TODO: 実装せよ
  end
end
