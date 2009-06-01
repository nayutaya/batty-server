
require 'test_helper'

class EmailsControllerTest < ActionController::TestCase
  def setup
    @yuya           = users(:yuya)
    @yuya_gmail     = email_addresses(:yuya_gmail)
    @shinya_example = email_addresses(:shinya_example)

    @edit_form = EmailAddressEditForm.new(
      :email => "email@example.jp")

    session_login(@yuya)
  end

  test "routes" do
    base = {:controller => "emails"}

    assert_routing("/emails/new",     base.merge(:action => "new"))
    assert_routing("/emails/create",  base.merge(:action => "create"))

    assert_routing("/email/1234567890/created", base.merge(:action => "created", :email_address_id => "1234567890"))
    assert_routing("/email/1234567890/delete",  base.merge(:action => "delete",  :email_address_id => "1234567890"))
    assert_routing("/email/1234567890/destroy", base.merge(:action => "destroy", :email_address_id => "1234567890"))

    assert_routing("/email/token/0123456789/activation", base.merge(:action => "activation", :activation_token => "0123456789"))
    assert_routing("/email/token/0123456789/activate",   base.merge(:action => "activate",   :activation_token => "0123456789"))
    assert_routing("/email/token/0123456789/activated",  base.merge(:action => "activated",  :activation_token => "0123456789"))
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
    assert_redirected_to(:controller => "emails", :action => "created", :email_address_id => assigns(:email_address).id)
    assert_flash_notice
    assert_logged_in(@yuya)

    assert_equal(
      @edit_form.attributes,
      assigns(:edit_form).attributes)

    assert_equal(@yuya.id,         assigns(:email_address).user_id)
    assert_equal(@edit_form.email, assigns(:email_address).email)
    assert_equal(nil,              assigns(:email_address).activated_at)

    # TODO: アクティベーションメールを送信
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

  test "GET created" do
    get :created, :email_address_id => @yuya_gmail.id

    assert_response(:success)
    assert_template("created")
    assert_flash_empty
    assert_logged_in(@yuya)

    assert_equal(@yuya_gmail, assigns(:email_address))
  end

  test "GET created, abnormal, no login" do
    session_logout

    get :created

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET created, abnormal, no email address id" do
    get :created, :email_address_id => nil

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET created, abnormal, other's email address" do
    get :created, :email_address_id => @shinya_example.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET delete" do
    get :delete, :email_address_id => @yuya_gmail.id

    assert_response(:success)
    assert_template("delete")
    assert_flash_empty
    assert_logged_in(@yuya)

    assert_equal(@yuya_gmail, assigns(:email_address))
  end

  test "GET delete, abnormal, no login" do
    session_logout

    get :delete

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET delete, abnormal, no email address id" do
    get :delete, :email_address_id => nil

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET delete, abnormal, other's email address" do
    get :delete, :email_address_id => @shinya_example.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST destroy" do
    assert_difference("EmailAddress.count", -1) {
      post :destroy, :email_address_id => @yuya_gmail.id
    }

    assert_response(:redirect)
    assert_redirected_to(:controller => "settings", :action => "index")
    assert_flash_notice
    assert_logged_in(@yuya)

    assert_equal(@yuya_gmail, assigns(:email_address))

    assert_equal(nil, EmailAddress.find_by_id(@yuya_gmail.id))
  end

  test "GET destroy, abnormal, method not allowed" do
    get :destroy

    assert_response(405)
    assert_template(nil)
  end

  test "POST destroy, abnormal, no login" do
    session_logout

    post :destroy

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST destroy, abnormal, no email address id" do
    post :destroy, :email_address_id => nil

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST destroy, abnormal, other's email address" do
    post :destroy, :email_address_id => @shinya_example.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end
end
