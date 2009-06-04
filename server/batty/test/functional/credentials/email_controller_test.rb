
require 'test_helper'

class Credentials::EmailControllerTest < ActionController::TestCase
  def setup
    @yuya          = users(:yuya)
    @yuya_gmail    = email_credentials(:yuya_gmail)
    @yuya_nayutaya = email_credentials(:yuya_nayutaya)
    @risa_example  = email_credentials(:risa_example)

    @edit_form = EmailCredentialEditForm.new(
      :email                 => "email@example.jp",
      :password              => "password",
      :password_confirmation => "password")

    @password_edit_form = EmailPasswordEditForm.new(
      :password              => "password",
      :password_confirmation => "password")

    session_login(@yuya)
  end

  test "routes" do
    base = {:controller => "credentials/email"}

    assert_routing("/credentials/email/new",    base.merge(:action => "new"))
    assert_routing("/credentials/email/create", base.merge(:action => "create"))

    assert_routing("/credential/email/1234567890/created",         base.merge(:action => "created",         :email_credential_id => "1234567890"))
    assert_routing("/credential/email/1234567890/edit_password",   base.merge(:action => "edit_password",   :email_credential_id => "1234567890"))
    assert_routing("/credential/email/1234567890/update_password", base.merge(:action => "update_password", :email_credential_id => "1234567890"))
    assert_routing("/credential/email/1234567890/delete",          base.merge(:action => "delete",          :email_credential_id => "1234567890"))
    assert_routing("/credential/email/1234567890/destroy",         base.merge(:action => "destroy",         :email_credential_id => "1234567890"))

    assert_routing("/credential/email/token/0123456789/activation", base.merge(:action => "activation", :activation_token => "0123456789"))
    assert_routing("/credential/email/token/0123456789/activate",   base.merge(:action => "activate",   :activation_token => "0123456789"))
    assert_routing("/credential/email/token/0123456789/activated",  base.merge(:action => "activated",  :activation_token => "0123456789"))
  end

  test "GET new" do
    get :new

    assert_response(:success)
    assert_template("new")
    assert_flash_empty
    assert_logged_in(@yuya)

    assert_equal(
      EmailCredentialEditForm.new.attributes,
      assigns(:edit_form).attributes)
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

    assert_difference("EmailCredential.count", +1) {
      post :create, :edit_form => @edit_form.attributes
    }

    assert_response(:redirect)
    assert_redirected_to(:controller => "credentials/email", :action => "created", :email_credential_id => assigns(:email_credential).id)
    assert_flash_notice
    assert_logged_in(@yuya)

    assert_equal(
      @edit_form.attributes,
      assigns(:edit_form).attributes)

    assigns(:email_credential).reload
    assert_equal(@yuya.id,         assigns(:email_credential).user_id)
    assert_equal(@edit_form.email, assigns(:email_credential).email)
    assert_equal(true, EmailCredential.compare_hashed_password(@edit_form.password, assigns(:email_credential).hashed_password))
    assert_equal(nil,              assigns(:email_credential).activated_at)

    # TODO: アクティベーションメールを送信
  end

  test "POST create, invalid form" do
    @edit_form.email = nil
    assert_equal(false, @edit_form.valid?)

    assert_difference("EmailCredential.count", 0) {
      post :create, :edit_form => @edit_form.attributes
    }

    assert_response(:success)
    assert_template("new")
    assert_flash_error

    assert_equal(nil, assigns(:edit_form).password)
    assert_equal(nil, assigns(:edit_form).password_confirmation)
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

  test "GET created" do
    get :created, :email_credential_id => @yuya_gmail.id

    assert_response(:success)
    assert_template("created")
    assert_flash_empty
    assert_logged_in(@yuya)

    assert_equal(@yuya_gmail, assigns(:email_credential))
  end

  test "GET created, abnormal, no login" do
    session_logout

    get :created, :email_credential_id => @yuya_gmail.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET created, abnormal, invalid email credential id" do
    get :created, :email_credential_id => "0"

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET created, abnormal, other's email credential" do
    get :created, :email_credential_id => @risa_example.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET edit_password" do
    get :edit_password, :email_credential_id => @yuya_gmail.id

    assert_response(:success)
    assert_template("edit_password")
    assert_flash_empty
    assert_logged_in(@yuya)

    assert_equal(@yuya_gmail, assigns(:email_credential))

    assert_equal(
      EmailPasswordEditForm.new.attributes,
      assigns(:edit_form).attributes)
  end

  test "GET edit_password, abnormal, no login" do
    session_logout

    get :edit_password, :email_credential_id => @yuya_gmail.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET edit_password, abnormal, invalid email credential id" do
    get :edit_password, :email_credential_id => "0"

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET edit_password, abnormal, other's email credential" do
    get :edit_password, :email_credential_id => @risa_example.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST update_password" do
    assert_equal(true, @password_edit_form.valid?)

    post :update_password, :email_credential_id => @yuya_gmail.id, :edit_form => @password_edit_form.attributes

    assert_response(:redirect)
    assert_redirected_to(:controller => "/credentials", :action => "index")
    assert_flash_notice
    assert_logged_in(@yuya)

    assert_equal(@yuya_gmail, assigns(:email_credential))

    assert_equal(
      @password_edit_form.attributes,
      assigns(:edit_form).attributes)

    assigns(:email_credential).reload
    assert_equal(
      true,
      EmailCredential.compare_hashed_password(@password_edit_form.password, assigns(:email_credential).hashed_password))
  end

  test "POST update_password, invalid form" do
    @password_edit_form.password = "x"
    assert_equal(false, @password_edit_form.valid?)

    post :update_password, :email_credential_id => @yuya_gmail.id, :edit_form => @password_edit_form.attributes

    assert_response(:success)
    assert_template("edit_password")
    assert_flash_error

    assert_equal(nil, assigns(:edit_form).password)
    assert_equal(nil, assigns(:edit_form).password_confirmation)
  end

  test "GET update_password, abnormal, method not allowed" do
    get :update_password, :email_credential_id => @yuya_gmail.id

    assert_response(405)
    assert_template(nil)
  end

  test "POST update_password, abnormal, no login" do
    session_logout

    post :update_password, :email_credential_id => @yuya_gmail.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST update_password, abnormal, invalid email credential id" do
    post :update_password, :email_credential_id => "0"

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST update_password, abnormal, other's email credential" do
    post :update_password, :email_credential_id => @risa_example.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET delete" do
    get :delete, :email_credential_id => @yuya_gmail.id

    assert_response(:success)
    assert_template("delete")
    assert_flash_empty
    assert_logged_in(@yuya)

    assert_equal(@yuya_gmail, assigns(:email_credential))
  end

  test "GET delete, abnormal, no login" do
    session_logout

    get :delete, :email_credential_id => @yuya_gmail.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET delete, abnormal, invalid email credential id" do
    get :delete, :email_credential_id => "0"

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET delete, abnormal, other's email credential" do
    get :delete, :email_credential_id => @risa_example.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST destroy" do
    assert_difference("EmailCredential.count", -1) {
      post :destroy, :email_credential_id => @yuya_gmail.id
    }

    assert_response(:redirect)
    assert_redirected_to(:controller => "/credentials", :action => "index")
    assert_flash_notice
    assert_logged_in(@yuya)

    assert_equal(@yuya_gmail, assigns(:email_credential))

    assert_equal(nil, EmailCredential.find_by_id(@yuya_gmail.id))
  end

  test "GET destroy, abnormal, method not allowed" do
    get :destroy, :email_credential_id => @yuya_gmail.id

    assert_response(405)
    assert_template(nil)
  end

  test "POST destroy, abnormal, no login" do
    session_logout

    post :destroy, :email_credential_id => @yuya_gmail.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST destroy, abnormal, invalid email credential id" do
    post :destroy, :email_credential_id => "0"

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST destroy, abnormal, other's email credential" do
    post :destroy, :email_credential_id => @risa_example.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET activation" do
    assert_equal(false, @yuya_nayutaya.activated?)

    get :activation, :activation_token => @yuya_nayutaya.activation_token

    assert_response(:success)
    assert_template("activation")
    assert_flash_empty
    assert_logged_in(@yuya)

    assert_equal(@yuya_nayutaya, assigns(:email_credential))
  end

  test "GET activation, no login" do
    session_logout
    assert_equal(false, @yuya_nayutaya.activated?)

    get :activation, :activation_token => @yuya_nayutaya.activation_token

    assert_response(:success)
    assert_template("activation")
    assert_flash_empty
    assert_not_logged_in

    assert_equal(@yuya_nayutaya, assigns(:email_credential))
  end

  test "GET activation, abnormal, invalid activation token" do
    get :activation, :activation_token => "0"

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET activation, abnormal, already activated" do
    assert_equal(true, @yuya_gmail.activated?)

    get :activation, :activation_token => @yuya_gmail.activation_token

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST activate" do
    time = Time.local(2009, 1, 1)
    assert_equal(false, @yuya_nayutaya.activated?)

    Kagemusha::DateTime.at(time) {
      post :activate, :activation_token => @yuya_nayutaya.activation_token
    }

    assert_response(:redirect)
    assert_redirected_to(:controller => "credentials/email", :action => "activated")
    assert_flash_empty
    assert_logged_in(@yuya)

    assert_equal(@yuya_nayutaya, assigns(:email_credential))

    assigns(:email_credential).reload
    assert_equal(true, assigns(:email_credential).activated?)
    assert_equal(time, assigns(:email_credential).activated_at)
  end

  test "POST activate, no login" do
    session_logout
    assert_equal(false, @yuya_nayutaya.activated?)

    post :activate, :activation_token => @yuya_nayutaya.activation_token

    assert_response(:redirect)
    assert_redirected_to(:controller => "credentials/email", :action => "activated")
    assert_flash_empty
    assert_not_logged_in

    assert_equal(@yuya_nayutaya, assigns(:email_credential))
  end

  test "GET activate, abnormal, method not allowed" do
    get :activate, :activation_token => @yuya_nayutaya.activation_token

    assert_response(405)
    assert_template(nil)
  end

  test "POST activate, abnormal, invalid activation token" do
    post :activate, :activation_token => "0"

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST activate, abnormal, already activated" do
    assert_equal(true, @yuya_gmail.activated?)

    post :activate, :activation_token => @yuya_gmail.activation_token

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET activated" do
    get :activated, :activation_token => @yuya_nayutaya.activation_token

    assert_response(:success)
    assert_template("activated")
    assert_flash_empty
    assert_logged_in(@yuya)

    assert_equal(@yuya_nayutaya, assigns(:email_credential))
  end

  test "GET activated, no login" do
    session_logout

    get :activated, :activation_token => @yuya_nayutaya.activation_token

    assert_response(:success)
    assert_template("activated")
    assert_flash_empty
    assert_not_logged_in

    assert_equal(@yuya_nayutaya, assigns(:email_credential))
  end

  test "GET activated, abnormal, invalid activation token" do
    get :activated, :activation_token => "0"

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end
end
