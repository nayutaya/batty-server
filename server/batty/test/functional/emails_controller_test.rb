
require 'test_helper'

class EmailsControllerTest < ActionController::TestCase
  def setup
    @yuya = users(:yuya)

    @edit_form = EmailAddressEditForm.new(
      :email => "email@example.jp")

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

  test "POST create" do
    assert_equal(true, @edit_form.valid?)

    assert_difference("EmailAddress.count", +1) {
      post :create, :edit_form => @edit_form.attributes
    }

    assert_response(:redirect)
    assert_redirected_to(:controller => "settings", :action => "index")
    assert_flash_notice
    assert_logged_in(@yuya)

    assert_equal(
      @edit_form.attributes,
      assigns(:edit_form).attributes)

    assert_equal(@yuya.id,         assigns(:email_address).user_id)
    assert_equal(@edit_form.email, assigns(:email_address).email)
    assert_equal(nil,              assigns(:email_address).activated_at)
  end

  test "POST create, invalid form" do
    @edit_form.email = nil
    assert_equal(false, @edit_form.valid?)

    assert_difference("EmailAddress.count", 0) {
      post :create, :edit_form => @edit_form.attributes
    }

    assert_response(:success)
    assert_template("new")
    assert_flash_error
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
end
