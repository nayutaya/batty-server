
require 'test_helper'

class EmailSignupControllerTest < ActionController::TestCase
  def setup
    @signup_form = EmailSignupForm.new

    @valid_signup_form_attributes = {
      :email                 => "foo@example.com",
      :password              => "password",
      :password_confirmation => "password",
    }
    @invalid_sinup_form_attributes = {
      :email                 => "a",
      :password              => "b",
      :password_confirmation => "c",
    }
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

    @signup_form.attributes = @valid_signup_form_attributes
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

    @signup_form.attributes = @invalid_sinup_form_attributes
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
    @signup_form.attributes = @valid_signup_form_attributes
    assert_equal(true, @signup_form.valid?)

    @request.session[:user_id]     = :dummy
    @request.session[:signup_form] = @signup_form.attributes

    get :validated

    assert_response(:success)
    assert_template("validated")
    # TODO: flash

    assert_equal(nil, @request.session[:user_id])

    assert_equal(
      @signup_form.attributes,
      assigns(:signup_form).attributes)
  end

  test "GET validated, invalid form" do
    @signup_form.attributes = @invalid_sinup_form_attributes
    assert_equal(false, @signup_form.valid?)

    get :validated

    assert_response(:success)
    assert_template("index")
    # TODO: flash
  end

  # TODO: セッションにデータなし

  test "POST create" do
    @signup_form.attributes = @valid_signup_form_attributes
    assert_equal(true, @signup_form.valid?)

    @request.session[:user_id]     = :dummy
    @request.session[:signup_form] = @signup_form.attributes

    assert_difference("EmailCredential.count", +1) {
      assert_difference("User.count", +1) {
        post :create
      }
    }

    assert_response(:redirect)
    assert_redirected_to(:controller => "email_signup", :action => "created")
    # TODO: flash

    assert_equal(nil, @request.session[:user_id])

    assert_equal(
      @signup_form.attributes,
      assigns(:signup_form).attributes)

    assert_equal(nil, assigns(:user).nickname)

    assert_equal(
      assigns(:user).id,
      assigns(:credential).user_id)
    assert_equal(
      @signup_form.email,
      assigns(:credential).email)
    assert_equal(
      true,
      EmailCredential.compare_hashed_password(@signup_form.password, assigns(:credential).hashed_password))
  end
  # TODO: GET method

  test "POST create, invalid form" do
    @signup_form.attributes = @invalid_signup_form_attributes
    assert_equal(false, @signup_form.valid?)

    @request.session[:signup_form] = @signup_form.attributes

    post :create

    assert_response(:success)
    assert_template("index")
    # TODO: flash
  end

  test "GET created" do
    @signup_form.email = email_credentials(:yuya_gmail).email

    @request.session[:user_id]     = :dummy
    @request.session[:signup_form] = @signup_form.attributes

    get :created

    assert_response(:success)
    assert_template("created")
    # TODO: flash

    assert_equal(nil, @request.session[:user_id])

    assert_equal(
      @signup_form.attributes,
      assigns(:signup_form).attributes)
    assert_equal(
      @signup_form.email,
      assigns(:credential).email)
  end

  test "GET activation" do
    credential = email_credentials(:yuya_nayutaya)

    get :activation, :activation_token => credential.activation_token

    assert_response(:success)
    assert_template("activation")
    # TODO: flash   

    assert_equal(credential, assigns(:credential))
    assert_equal(false, assigns(:activated))
  end

  test "GET activation, already activated" do
    credential = email_credentials(:yuya_gmail)

    get :activation, :activation_token => credential.activation_token

    assert_response(:success)
    assert_template("activation")
    # TODO: flash

    assert_equal(credential, assigns(:credential))
    assert_equal(true, assigns(:activated))
  end

  test "GET activation, abnormal, no activation token" do
    get :activation, :activation_token => nil

    assert_response(:success)
    assert_template("activation")
    # TODO: flash

    assert_equal(nil, assigns(:credential))
    assert_equal(nil, assigns(:activated))
  end

  test "POST activate" do
    post :activate

    assert_response(:redirect)
    assert_redirected_to(:controller => "email_signup", :action => "activated")
    # TODO: flash
  end
  # TODO: GET method

  test "GET activated" do
    get :activated

    assert_response(:success)
    assert_template("activated")
    # TODO: flash   
  end
end
