
require 'test_helper'

class EmailsControllerTest < ActionController::TestCase
  def setup
    @yuya = users(:yuya)

    session_login(@yuya)
  end

  test "routes" do
    base = {:controller => "emails"}

    assert_routing("/emails/new",    base.merge(:action => "new"))
    assert_routing("/emails/create", base.merge(:action => "create"))
  end

  test "GET new" do
    get :new

    assert_response(:success)
    assert_template("new")
    assert_flash_empty
    assert_logged_in(@yuya)

    assert_equal(
      EmailAddressEditForm.new.attributes,
      assigns(:edit_form).attributes)
  end

  test "GET new, abnormal, no login" do
    session_logout

    get :new

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end
end
