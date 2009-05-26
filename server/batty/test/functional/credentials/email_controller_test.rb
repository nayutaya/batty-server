
require 'test_helper'

class Credentials::EmailControllerTest < ActionController::TestCase
  def setup
    @yuya         = users(:yuya)
    @yuya_gmail   = email_credentials(:yuya_gmail)
    @risa_example = email_credentials(:risa_example)

    session_login(@yuya)
  end

  test "routes" do
    base = {:controller => "credentials/email"}

    assert_routing("/credential/email/1234567890/edit_password",   base.merge(:action => "edit_password",   :email_credential_id => "1234567890"))
    assert_routing("/credential/email/1234567890/update_password", base.merge(:action => "update_password", :email_credential_id => "1234567890"))
  end

  test "GET edit_password" do
    get :edit_password, :email_credential_id => @yuya_gmail.id

    assert_response(:success)
    assert_template("edit_password")
    assert_flash_empty
    assert_logged_in(@yuya)

    assert_equal(@yuya_gmail, assigns(:email_credential))

    # TODO: 編集フォームの処理を実装せよ
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
end
