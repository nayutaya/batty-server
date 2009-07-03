
require 'test_helper'

class Admin::HomeControllerTest < ActionController::TestCase
  test "routes" do
    base = {:controller => "admin/home"}

    assert_routing("/admin", base.merge(:action => "index"))
  end

  test "GET index" do
    get :index

    assert_response(:success)
    assert_template("index")
  end

  test "GET index, abnormal, remote host not allowed" do
    musha = Kagemusha.new(ActionController::TestRequest).def(:remote_ip) { "123.123.123.123" }
    musha.swap {
      get :index
    }

    assert_response(:redirect)
    assert_redirected_to(root_path)
  end
end
