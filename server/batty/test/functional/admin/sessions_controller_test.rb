
require 'test_helper'

class Admin::SessionsControllerTest < ActionController::TestCase
  test "routes" do
    base = {:controller => "admin/sessions"}

    assert_routing("/admin/sessions",         base.merge(:action => "index"))
    assert_routing("/admin/sessions/cleanup", base.merge(:action => "cleanup"))
  end

  test "GET index" do
    get :index

    assert_response(:success)
    assert_template("index")

    assert_equal( 1, assigns(:sessions).current_page)
    assert_equal(20, assigns(:sessions).per_page)
  end

  test "GET index, page 2" do
    get :index, :page => 2

    assert_response(:success)
    assert_template("index")

    assert_equal( 2, assigns(:sessions).current_page)
    assert_equal(20, assigns(:sessions).per_page)
  end

  test "GET index, abnormal, remote host not allowed" do
    musha = Kagemusha.new(ActionController::TestRequest).def(:remote_ip) { "123.123.123.123" }
    musha.swap {
      get :index
    }

    assert_response(:redirect)
    assert_redirected_to(root_path)
  end

  test "POST cleanup" do
    seconds = nil
    musha = Kagemusha.new(Session)
    musha.defs(:cleanup) { |_seconds| seconds = _seconds; nil }

    musha.swap {
      post :cleanup
    }

    assert_response(:redirect)
    assert_redirected_to(:action => "index")

    assert_equal(3.days, seconds)
  end

  test "GET cleanup, abnormal, method not allowed" do
    get :cleanup

    assert_response(405)
    assert_template(nil)
  end
end
