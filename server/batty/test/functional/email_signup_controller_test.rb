
require 'test_helper'

class EmailSignupControllerTest < ActionController::TestCase
  def setup
    @signup_form = EmailSignupForm.new
  end

  test "routes" do
    base = {:controller => "email_signup"}

    assert_routing("/signup/email",                       base.merge(:action => "index"))
    assert_routing("/signup/email/validate",              base.merge(:action => "validate"))
    assert_routing("/signup/email/validated",             base.merge(:action => "validated"))
    assert_routing("/signup/email/create",                base.merge(:action => "create"))
    assert_routing("/signup/email/created",               base.merge(:action => "created"))
    assert_routing("/signup/email/activation/0123456789", base.merge(:action => "activation", :activation_token => "0123456789"))
    assert_routing("/signup/email/activation/abcdef",     base.merge(:action => "activation", :activation_token => "abcdef"))
    assert_routing("/signup/email/activate",              base.merge(:action => "activate"))
    assert_routing("/signup/email/activated",             base.merge(:action => "activated"))
  end

  test "GET index" do
    @request.session[:signup_form] = :dummy
    session_login(users(:yuya))

    get :index

    assert_response(:success)
    assert_template("index")
    assert_flash_empty
    assert_not_logged_in

    assert_equal(nil, @request.session[:signup_form])

    assert_equal(
      EmailSignupForm.new.attributes,
      assigns(:signup_form).attributes)
  end

  test "POST validate" do
    @request.session[:signup_form] = :dummy
    session_login(users(:yuya))

    @signup_form.attributes = {
      :email                 => "foo@example.com",
      :password              => "password",
      :password_confirmation => "password",
    }
    assert_equal(true, @signup_form.valid?)

    post :validate, :signup_form => @signup_form.attributes

    assert_response(:redirect)
    assert_redirected_to(:controller => "email_signup", :action => "validated")
    # TODO: flash
    assert_not_logged_in

    assert_equal(
      @signup_form.attributes,
      assigns(:signup_form).attributes)

    assert_equal(
      @signup_form.attributes,
      @request.session[:signup_form])
  end

  test "POST validate, invalid form" do
    @request.session[:signup_form] = :dummy

    @signup_form.attributes = {
      :email                 => "a",
      :password              => "b",
      :password_confirmation => "c",
    }
    assert_equal(false, @signup_form.valid?)

    post :validate, :signup_form => @signup_form.attributes

    assert_response(:success)
    assert_template("index")
    # TODO: flash

    assert_equal(nil, @request.session[:signup_form])

    assert_equal(nil, assigns(:signup_form).password)
    assert_equal(nil, assigns(:signup_form).password_confirmation)
  end

  test "GET validate, abnormal, method not allowed" do
    get :validate

    assert_response(405)
    assert_template(nil)
  end

  test "GET validated" do
    get :validated

    assert_response(:success)
    assert_template("validated")
    # TODO: flash   
  end
  # TODO: セッションにデータなし

  test "POST create" do
    post :create

    assert_response(:redirect)
    assert_redirected_to(:controller => "email_signup", :action => "created")
    # TODO: flash
  end
  # TODO: GET method

  test "GET created" do
    get :created

    assert_response(:success)
    assert_template("created")
    # TODO: flash   
  end

  test "GET activation" do
    get :activation

    assert_response(:success)
    assert_template("activation")
    # TODO: flash   
  end

  test "POST activate" do
    post :activate

    assert_response(:redirect)
    assert_redirected_to(:controller => "email_signup", :action => "activated")
    # TODO: flash
  end

  test "GET activated" do
    get :activated

    assert_response(:success)
    assert_template("activated")
    # TODO: flash   
  end
end
