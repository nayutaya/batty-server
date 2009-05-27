
require 'test_helper'

class Credentials::OpenIdControllerTest < ActionController::TestCase
  test "routes" do
    base = {:controller => "credentials/open_id"}

    assert_routing("/credential/open_id/1234567890/delete",  base.merge(:action => "delete",  :open_id_credential_id => "1234567890"))
    assert_routing("/credential/open_id/1234567890/destroy", base.merge(:action => "destroy", :open_id_credential_id => "1234567890"))
  end
end
