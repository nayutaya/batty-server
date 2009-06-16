
require 'test_helper'

class EmailActionsControllerTest < ActionController::TestCase
  def setup
    @yuya              = users(:yuya)
    @yuya_pda          = devices(:yuya_pda)
    @shinya_note       = devices(:shinya_note)
    @yuya_pda_ge90     = triggers(:yuya_pda_ge90)
    @shinya_note_ne0   = triggers(:shinya_note_ne0)
    @yuya_pda_ge90_1   = email_actions(:yuya_pda_ge90_1)
    @shinya_note_ne0_1 = email_actions(:shinya_note_ne0_1)

    @edit_form = EmailActionEditForm.new(
      :enable  => true,
      :email   => email_addresses(:yuya_gmail).email,
      :subject => "subject",
      :body    => "body")

    session_login(@yuya)
  end

  test "routes" do
    base = {:controller => "email_actions"}

    assert_routing("/device/1234567890/trigger/2345678901/acts/email/new",    base.merge(:action => "new",    :device_id => "1234567890", :trigger_id => "2345678901"))
    assert_routing("/device/1234567890/trigger/2345678901/acts/email/create", base.merge(:action => "create", :device_id => "1234567890", :trigger_id => "2345678901"))

    assert_routing("/device/1234567890/trigger/2345678901/act/email/3456789012/edit",    base.merge(:action => "edit",    :device_id => "1234567890", :trigger_id => "2345678901", :email_action_id => "3456789012"))
    assert_routing("/device/1234567890/trigger/2345678901/act/email/3456789012/update",  base.merge(:action => "update",  :device_id => "1234567890", :trigger_id => "2345678901", :email_action_id => "3456789012"))
    assert_routing("/device/1234567890/trigger/2345678901/act/email/3456789012/delete",  base.merge(:action => "delete",  :device_id => "1234567890", :trigger_id => "2345678901", :email_action_id => "3456789012"))
    assert_routing("/device/1234567890/trigger/2345678901/act/email/3456789012/destroy", base.merge(:action => "destroy", :device_id => "1234567890", :trigger_id => "2345678901", :email_action_id => "3456789012"))
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
      EmailActionEditForm.new(:enable => true).attributes,
      assigns(:edit_form).attributes)

    assert_equal(
      EmailActionEditForm.email_addresses_for_select(@yuya, :include_blank => true),
      assigns(:email_addresses_for_select))
  end

  test "GET new, abnormal, no login" do
    session_logout

    get :new, :device_id => @yuya_pda.id, :trigger_id => @yuya_pda_ge90.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET new, abnormal, invalid device id" do
    get :new, :device_id => "0", :trigger_id => @yuya_pda_ge90.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET new, abnormal, invalid trigger id" do
    get :new, :device_id => @yuya_pda.id, :trigger_id => "0"

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
    get :new, :device_id => @yuya_pda.id, :trigger_id => @shinya_note_ne0.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST create" do
    assert_equal(true, @edit_form.valid?)

    assert_difference("EmailAction.count", +1) {
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
      post :create, :device_id => @yuya_pda.id, :trigger_id => @yuya_pda_ge90.id, :edit_form => @edit_form.attributes
    }

    assert_response(:success)
    assert_template("new")
    assert_flash_error

    assert_equal(
      EmailActionEditForm.email_addresses_for_select(@yuya, :include_blank => true),
      assigns(:email_addresses_for_select))
  end

  test "GET create, abnormal, method not allowed" do
    get :create, :device_id => @yuya_pda.id, :trigger_id => @yuya_pda_ge90.id

    assert_response(405)
    assert_template(nil)
  end

  test "POST create, abnormal, no login" do
    session_logout

    post :create, :device_id => @yuya_pda.id, :trigger_id => @yuya_pda_ge90.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST create, abnormal, invalid device id" do
    post :create, :device_id => "0", :trigger_id => @yuya_pda_ge90.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST create, abnormal, invalid trigger id" do
    post :create, :device_id => @yuya_pda.id, :trigger_id => "0"

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
    post :create, :device_id => @yuya_pda.id, :trigger_id => @shinya_note_ne0.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET edit" do
    get :edit, :device_id => @yuya_pda.id, :trigger_id => @yuya_pda_ge90.id, :email_action_id => @yuya_pda_ge90_1.id

    assert_response(:success)
    assert_template("edit")
    assert_flash_empty
    assert_logged_in(@yuya)
  
    assert_equal(@yuya_pda, assigns(:device))
    assert_equal(@yuya_pda_ge90, assigns(:trigger))
    assert_equal(@yuya_pda_ge90_1, assigns(:email_action))

    assert_equal(@yuya_pda_ge90_1.enable,  assigns(:edit_form).enable)
    assert_equal(@yuya_pda_ge90_1.email,   assigns(:edit_form).email)
    assert_equal(@yuya_pda_ge90_1.subject, assigns(:edit_form).subject)
    assert_equal(@yuya_pda_ge90_1.body,    assigns(:edit_form).body)

    assert_equal(
      EmailActionEditForm.email_addresses_for_select(@yuya, :include_blank => false, :selected => @yuya_pda_ge90_1.email),
      assigns(:email_addresses_for_select))
  end

  test "GET edit, abnormal, no login" do
    session_logout

    get :edit, :device_id => @yuya_pda.id, :trigger_id => @yuya_pda_ge90.id, :email_action_id => @yuya_pda_ge90_1.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET edit, abnormal, invalid device id" do
    get :edit, :device_id => "0", :trigger_id => @yuya_pda_ge90.id, :email_action_id => @yuya_pda_ge90_1.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET edit, abnormal, invalid trigger id" do
    get :edit, :device_id => @yuya_pda.id, :trigger_id => "0", :email_action_id => @yuya_pda_ge90_1.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET edit, abnormal, invalid email action id" do
    get :edit, :device_id => @yuya_pda.id, :trigger_id => @yuya_pda_ge90.id, :email_action_id => "0"

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET edit, abnormal, other's device" do
    get :edit, :device_id => @shinya_note.id, :trigger_id => @yuya_pda_ge90.id, :email_action_id => @yuya_pda_ge90_1.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET edit, abnormal, other's trigger" do
    get :edit, :device_id => @yuya_pda.id, :trigger_id => @shinya_note_ne0.id, :email_action_id => @yuya_pda_ge90_1.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET edit, abnormal, other's email action" do
    get :edit, :device_id => @yuya_pda.id, :trigger_id => @yuya_pda_ge90.id, :email_action_id => @shinya_note_ne0_1.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST update" do
    @edit_form.enable = false
    assert_equal(true, @edit_form.valid?)

    post :update, :device_id => @yuya_pda.id, :trigger_id => @yuya_pda_ge90.id, :email_action_id => @yuya_pda_ge90_1.id, :edit_form => @edit_form.attributes

    assert_response(:redirect)
    assert_redirected_to(:controller => "devices", :action => "show", :device_id => @yuya_pda.id)
    assert_flash_notice
    assert_logged_in(@yuya)

    assert_equal(@yuya_pda, assigns(:device))
    assert_equal(@yuya_pda_ge90, assigns(:trigger))
    assert_equal(@yuya_pda_ge90_1, assigns(:email_action))

    @yuya_pda_ge90_1.reload
    assert_equal(@edit_form.enable,  @yuya_pda_ge90_1.enable)
    assert_equal(@edit_form.email,   @yuya_pda_ge90_1.email)
    assert_equal(@edit_form.subject, @yuya_pda_ge90_1.subject)
    assert_equal(@edit_form.body,    @yuya_pda_ge90_1.body)
  end

  test "POST update, invalid form" do
    @edit_form.email = nil
    assert_equal(false, @edit_form.valid?)

    post :update, :device_id => @yuya_pda.id, :trigger_id => @yuya_pda_ge90.id, :email_action_id => @yuya_pda_ge90_1.id, :edit_form => @edit_form.attributes

    assert_response(:success)
    assert_template("edit")
    assert_flash_error

    @yuya_pda_ge90_1.reload
    assert_not_equal(@edit_form.email, @yuya_pda_ge90_1.email)

    assert_equal(
      EmailActionEditForm.email_addresses_for_select(@yuya, :include_blank => false, :selected => @edit_form.email),
      assigns(:email_addresses_for_select))
  end

  test "GET update, abnormal, method not allowed" do
    get :update, :device_id => @yuya_pda.id, :trigger_id => @yuya_pda_ge90.id, :email_action_id => @yuya_pda_ge90_1.id

    assert_response(405)
    assert_template(nil)
  end

  test "POST update, abnormal, no login" do
    session_logout

    post :update, :device_id => @yuya_pda.id, :trigger_id => @yuya_pda_ge90.id, :email_action_id => @yuya_pda_ge90_1.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST update, abnormal, invalid device id" do
    post :update, :device_id => "0", :trigger_id => @yuya_pda_ge90.id, :email_action_id => @yuya_pda_ge90_1.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST update, abnormal, invalid trigger id" do
    post :update, :device_id => @yuya_pda.id, :trigger_id => "0", :email_action_id => @yuya_pda_ge90_1.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST update, abnormal, invalid email action id" do
    post :update, :device_id => @yuya_pda.id, :trigger_id => @yuya_pda_ge90.id, :email_action_id => "0"

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST update, abnormal, other's device" do
    post :update, :device_id => @shinya_note.id, :trigger_id => @yuya_pda_ge90.id, :email_action_id => @yuya_pda_ge90_1.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST update, abnormal, other's trigger" do
    post :update, :device_id => @yuya_pda.id, :trigger_id => @shinya_note_ne0.id, :email_action_id => @yuya_pda_ge90_1.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST update, abnormal, other's email action" do
    post :update, :device_id => @yuya_pda.id, :trigger_id => @yuya_pda_ge90.id, :email_action_id => @shinya_note_ne0_1.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET delete" do
    get :delete, :device_id => @yuya_pda.id, :trigger_id => @yuya_pda_ge90.id, :email_action_id => @yuya_pda_ge90_1.id

    assert_response(:success)
    assert_template("delete")
    assert_flash_empty
    assert_logged_in(@yuya)

    assert_equal(@yuya_pda, assigns(:device))
    assert_equal(@yuya_pda_ge90, assigns(:trigger))
    assert_equal(@yuya_pda_ge90_1, assigns(:email_action))
  end

  test "GET delete, abnormal, no login" do
    session_logout

    get :delete, :device_id => @yuya_pda.id, :trigger_id => @yuya_pda_ge90.id, :email_action_id => @yuya_pda_ge90_1.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET delete, abnormal, invalid device id" do
    get :delete, :device_id => "0", :trigger_id => @yuya_pda_ge90.id, :email_action_id => @yuya_pda_ge90_1.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET delete, abnormal, invalid trigger id" do
    get :delete, :device_id => @yuya_pda.id, :trigger_id => "0", :email_action_id => @yuya_pda_ge90_1.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET delete, abnormal, invalid email action id" do
    get :delete, :device_id => @yuya_pda.id, :trigger_id => @yuya_pda_ge90.id, :email_action_id => "0"

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET delete, abnormal, other's device" do
    get :delete, :device_id => @shinya_note.id, :trigger_id => @yuya_pda_ge90.id, :email_action_id => @yuya_pda_ge90_1.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET delete, abnormal, other's trigger" do
    get :delete, :device_id => @yuya_pda.id, :trigger_id => @shinya_note_ne0.id, :email_action_id => @yuya_pda_ge90_1.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET delete, abnormal, other's email action" do
    get :delete, :device_id => @yuya_pda.id, :trigger_id => @yuya_pda_ge90.id, :email_action_id => @shinya_note_ne0_1.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST destroy" do
    assert_difference("EmailAction.count", -1) {
      post :destroy, :device_id => @yuya_pda.id, :trigger_id => @yuya_pda_ge90.id, :email_action_id => @yuya_pda_ge90_1.id
    }

    assert_response(:redirect)
    assert_redirected_to(:controller => "devices", :action => "show", :device_id => @yuya_pda.id)
    assert_flash_notice
    assert_logged_in(@yuya)

    assert_equal(@yuya_pda, assigns(:device))
    assert_equal(@yuya_pda_ge90, assigns(:trigger))
    assert_equal(@yuya_pda_ge90_1, assigns(:email_action))

    assert_equal(nil, EmailAction.find_by_id(@yuya_pda_ge90_1.id))
  end

  test "GET destroy, abnormal, method not allowed" do
    get :destroy, :device_id => @yuya_pda.id, :trigger_id => @yuya_pda_ge90.id, :email_action_id => @yuya_pda_ge90_1.id

    assert_response(405)
    assert_template(nil)
  end

  test "POST destroy, abnormal, no login" do
    session_logout

    post :destroy, :device_id => @yuya_pda.id, :trigger_id => @yuya_pda_ge90.id, :email_action_id => @yuya_pda_ge90_1.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST destroy, abnormal, invalid device id" do
    post :destroy, :device_id => "0", :trigger_id => @yuya_pda_ge90.id, :email_action_id => @yuya_pda_ge90_1.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST destroy, abnormal, invalid trigger id" do
    post :destroy, :device_id => @yuya_pda.id, :trigger_id => "0", :email_action_id => @yuya_pda_ge90_1.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST destroy, abnormal, invalid email action id" do
    post :destroy, :device_id => @yuya_pda.id, :trigger_id => @yuya_pda_ge90.id, :email_action_id => "0"

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST destroy, abnormal, other's device" do
    post :destroy, :device_id => @shinya_note.id, :trigger_id => @yuya_pda_ge90.id, :email_action_id => @yuya_pda_ge90_1.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST destroy, abnormal, other's trigger" do
    post :destroy, :device_id => @yuya_pda.id, :trigger_id => @shinya_note_ne0.id, :email_action_id => @yuya_pda_ge90_1.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST destroy, abnormal, other's email action" do
    post :destroy, :device_id => @yuya_pda.id, :trigger_id => @yuya_pda_ge90.id, :email_action_id => @shinya_note_ne0_1.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end
end
