
require 'test_helper'

class Credentials::EmailControllerTest < ActionController::TestCase
  def setup
    @yuya         = users(:yuya)
    @yuya_gmail   = email_credentials(:yuya_gmail)
    @risa_example = email_credentials(:risa_example)

    @edit_form = EmailPasswordEditForm.new(
      :password              => "password",
      :password_confirmation => "password")

    session_login(@yuya)
  end

  test "routes" do
    base = {:controller => "credentials/email"}

    assert_routing("/credential/email/1234567890/edit_password",   base.merge(:action => "edit_password",   :email_credential_id => "1234567890"))
    assert_routing("/credential/email/1234567890/update_password", base.merge(:action => "update_password", :email_credential_id => "1234567890"))
    assert_routing("/credential/email/1234567890/delete",          base.merge(:action => "delete",          :email_credential_id => "1234567890"))
    assert_routing("/credential/email/1234567890/destroy",         base.merge(:action => "destroy",         :email_credential_id => "1234567890"))
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

    get :edit_password

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET edit_password, abnormal, no email credential id" do
    get :edit_password, :email_credential_id => nil

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
    assert_equal(true, @edit_form.valid?)

    post :update_password, :email_credential_id => @yuya_gmail.id, :edit_form => @edit_form.attributes

    assert_response(:redirect)
    assert_redirected_to(:controller => "/credentials", :action => "index")
    assert_flash_notice
    assert_logged_in(@yuya)

    assert_equal(@yuya_gmail, assigns(:email_credential))

    assert_equal(
      @edit_form.attributes,
      assigns(:edit_form).attributes)

    assigns(:email_credential).reload
    assert_equal(
      true,
      EmailCredential.compare_hashed_password(@edit_form.password, assigns(:email_credential).hashed_password))
  end

  test "POST update_password, invalid form" do
    @edit_form.password = "x"
    assert_equal(false, @edit_form.valid?)

    post :update_password, :email_credential_id => @yuya_gmail.id, :edit_form => @edit_form.attributes

    assert_response(:success)
    assert_template("edit_password")
    assert_flash_error

    assert_equal(nil, assigns(:edit_form).password)
    assert_equal(nil, assigns(:edit_form).password_confirmation)
  end

  test "GET update_password, abnormal, method not allowed" do
    get :update_password

    assert_response(405)
    assert_template(nil)
  end

  test "POST update_password, abnormal, no login" do
    session_logout

    post :update_password

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST update_password, abnormal, no email credential id" do
    post :update_password, :email_credential_id => nil

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

    get :delete

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET delete, abnormal, no email credential id" do
    get :delete, :email_credential_id => nil

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
end
