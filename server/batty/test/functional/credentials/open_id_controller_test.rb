
require 'test_helper'

class Credentials::OpenIdControllerTest < ActionController::TestCase
  def setup
    @yuya           = users(:yuya)
    @yuya_livedoor  = open_id_credentials(:yuya_livedoor)
    @shinya_example = open_id_credentials(:shinya_example)

    session_login(@yuya)
  end

  test "routes" do
    base = {:controller => "credentials/open_id"}

    assert_routing("/credential/open_id/1234567890/delete",  base.merge(:action => "delete",  :open_id_credential_id => "1234567890"))
    assert_routing("/credential/open_id/1234567890/destroy", base.merge(:action => "destroy", :open_id_credential_id => "1234567890"))
  end

  test "GET delete" do
    get :delete, :open_id_credential_id => @yuya_livedoor.id

    assert_response(:success)
    assert_template("delete")
    assert_flash_empty
    assert_logged_in(@yuya)

    assert_equal(@yuya_livedoor, assigns(:open_id_credential))
  end

  test "GET delete, abnormal, no login" do
    session_logout

    get :delete

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET delete, abnormal, no openid credential id" do
    get :delete, :open_id_credential_id => nil

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET delete, abnormal, other's openid credential" do
    get :delete, :open_id_credential_id => @shinya_example.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end
end
