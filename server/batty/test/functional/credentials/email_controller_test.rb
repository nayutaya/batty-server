
require 'test_helper'

class Credentials::EmailControllerTest < ActionController::TestCase
  test "routes" do
    base = {:controller => "credentials/email"}

    assert_routing("/credential/email/1234567890/edit_password",   base.merge(:action => "edit_password",   :email_credential_id => "1234567890"))
    assert_routing("/credential/email/1234567890/update_password", base.merge(:action => "update_password", :email_credential_id => "1234567890"))
  end
end
