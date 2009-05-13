
require 'test_helper'

class EmailAuthControllerTest < ActionController::TestCase
  test "routes" do
    base = {:controller => "email_auth"}

    assert_routing("/auth/email",       base.merge(:action => "index"))
    assert_routing("/auth/email/login", base.merge(:action => "login"))
  end
end
