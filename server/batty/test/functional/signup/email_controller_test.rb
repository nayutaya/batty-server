# -*- coding: utf-8 -*-

require 'test_helper'

class Signup::EmailControllerTest < ActionController::TestCase
  def setup
    @yuya_gmail    = email_credentials(:yuya_gmail)
    @yuya_nayutaya = email_credentials(:yuya_nayutaya)

    @signup_form = EmailCredentialEditForm.new(
      :email                 => "foo@example.com",
      :password              => "password",
      :password_confirmation => "password")

    ActionMailer::Base.deliveries = []
  end

  test "routes" do
    base = {:controller => "signup/email"}

    assert_routing("/signup/email",           base.merge(:action => "index"))
    assert_routing("/signup/email/validate",  base.merge(:action => "validate"))
    assert_routing("/signup/email/validated", base.merge(:action => "validated"))
    assert_routing("/signup/email/create",    base.merge(:action => "create"))
    assert_routing("/signup/email/created",   base.merge(:action => "created"))
    assert_routing("/signup/email/activation/0123456789abcdef", base.merge(:action => "activation", :activation_token => "0123456789abcdef"))
    assert_routing("/signup/email/activate",  base.merge(:action => "activate"))
    assert_routing("/signup/email/activated", base.merge(:action => "activated"))
  end

  test "GET index" do
    get :index

    assert_response(:success)
    assert_template("index")
    assert_flash_empty

    assert_equal(
      EmailCredentialEditForm.new.attributes,
      assigns(:signup_form).attributes)
  end

  test "GET index, clean session" do
    @request.session[:user_id]     = :dummy
    @request.session[:signup_form] = :dummy

    get :index

    assert_response(:success)
    assert_template("index")

    assert_equal(nil, @request.session[:user_id])
    assert_equal(nil, @request.session[:signup_form])
  end

  test "POST validate" do
    assert_equal(true, @signup_form.valid?)

    post :validate, :signup_form => @signup_form.attributes

    assert_response(:redirect)
    assert_redirected_to(:controller => "email", :action => "validated")
    assert_flash_empty

    assert_equal(
      @signup_form.attributes,
      assigns(:signup_form).attributes)

    assert_equal(
      @signup_form.attributes,
      @request.session[:signup_form])
  end

  test "POST validate, invalid form" do
    @request.session[:signup_form] = :dummy

    @signup_form.email = nil
    assert_equal(false, @signup_form.valid?)

    post :validate, :signup_form => @signup_form.attributes

    assert_response(:success)
    assert_template("index")
    assert_flash_error

    assert_equal(nil, @request.session[:signup_form])

    assert_equal(nil, assigns(:signup_form).password)
    assert_equal(nil, assigns(:signup_form).password_confirmation)
  end

  test "POST validate, clean session" do
    @request.session[:user_id]     = :dummy
    @request.session[:signup_form] = :dummy

    post :validate, :signup_form => @signup_form.attributes

    assert_response(:redirect)
    assert_redirected_to(:controller => "email", :action => "validated")

    assert_equal(nil, @request.session[:user_id])
  end

  test "GET validate, abnormal, method not allowed" do
    get :validate

    assert_response(405)
    assert_template(nil)
  end

  test "GET validated" do
    assert_equal(true, @signup_form.valid?)

    @request.session[:signup_form] = @signup_form.attributes

    get :validated

    assert_response(:success)
    assert_template("validated")
    assert_flash_empty

    assert_equal(
      @signup_form.attributes,
      assigns(:signup_form).attributes)
  end

  test "GET validated, invalid form" do
    @signup_form.email = nil
    assert_equal(false, @signup_form.valid?)

    get :validated

    assert_response(:success)
    assert_template("index")
    assert_flash_error
  end

  test "GET validated, clean session" do
    @request.session[:user_id]     = :dummy
    @request.session[:signup_form] = @signup_form.attributes

    get :validated

    assert_response(:success)
    assert_template("validated")

    assert_equal(nil, @request.session[:user_id])
  end

  test "POST create" do
    assert_equal(true, @signup_form.valid?)

    @request.session[:signup_form] = @signup_form.attributes

    assert_difference("EmailCredential.count", +1) {
      assert_difference("User.count", +1) {
        post :create
      }
    }

    assert_response(:redirect)
    assert_redirected_to(:controller => "email", :action => "created")
    assert_flash_empty

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

    # MEMO: ここではurl_forが使えない
    assert_equal(
      root_path(:only_path => false) + "signup/email/activation/" + assigns(:credential).activation_token,
      assigns(:activation_url))

    assert_equal(1, ActionMailer::Base.deliveries.size)
  end

  test "POST create, invalid form" do
    @signup_form.email = nil
    assert_equal(false, @signup_form.valid?)

    @request.session[:signup_form] = @signup_form.attributes

    post :create

    assert_response(:success)
    assert_template("index")
    assert_flash_error
  end

  test "POST create, clean session" do
    @request.session[:user_id]     = :dummy
    @request.session[:signup_form] = @signup_form.attributes

    post :create

    assert_response(:redirect)
    assert_redirected_to(:controller => "email", :action => "created")

    assert_equal(nil, @request.session[:user_id])
  end

  test "GET create, abnormal, method not allowed" do
    get :create

    assert_response(405)
    assert_template(nil)
  end

  test "GET created" do
    @signup_form.email = @yuya_nayutaya.email
    @request.session[:signup_form] = @signup_form.attributes

    get :created

    assert_response(:success)
    assert_template("created")
    assert_flash_empty

    assert_equal(
      @signup_form.attributes,
      assigns(:signup_form).attributes)
    assert_equal(
      @signup_form.email,
      assigns(:credential).email)
  end

  test "GET created, clean session" do
    @request.session[:user_id]     = :dummy
    @request.session[:signup_form] = {:email => @yuya_nayutaya.email}

    get :created

    assert_response(:success)
    assert_template("created")

    assert_equal(nil, @request.session[:user_id])
  end

  test "GET activation" do
    get :activation, :activation_token => @yuya_nayutaya.activation_token

    assert_response(:success)
    assert_template("activation")
    assert_flash_empty

    assert_equal(@yuya_nayutaya, assigns(:credential))
    assert_equal(false, assigns(:activated))
  end

  test "GET activation, already activated" do
    get :activation, :activation_token => @yuya_gmail.activation_token

    assert_response(:success)
    assert_template("activation")
    assert_flash_empty

    assert_equal(@yuya_gmail, assigns(:credential))
    assert_equal(true, assigns(:activated))
  end

  test "GET activation, clean session" do
    @request.session[:user_id]     = :dummy
    @request.session[:signup_form] = :dummy

    get :activation, :activation_token => @yuya_nayutaya.activation_token

    assert_response(:success)
    assert_template("activation")

    assert_equal(nil, @request.session[:user_id])
    assert_equal(nil, @request.session[:signup_form])
  end

  test "GET activation, abnormal, invalid activation token" do
    get :activation, :activation_token => "0"

    assert_response(:success)
    assert_template("activation")
    assert_flash_empty

    assert_equal(nil, assigns(:credential))
    assert_equal(nil, assigns(:activated))
  end

  test "POST activate" do
    time = Time.local(2010, 1, 1)

    Kagemusha::DateTime.at(time) {
      post :activate, :activation_token => @yuya_nayutaya.activation_token
    }

    assert_response(:redirect)
    assert_redirected_to(:controller => "email", :action => "activated")
    assert_flash_empty

    assigns(:credential).reload
    assert_equal(@yuya_nayutaya.email, assigns(:credential).email)
    assert_equal(time, assigns(:credential).activated_at)
  end

  test "POST activate, already activated" do
    post :activate, :activation_token => @yuya_gmail.activation_token

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST activate, clean session" do
    @request.session[:user_id]     = :dummy
    @request.session[:signup_form] = :dummy

    post :activate, :activation_token => @yuya_nayutaya.activation_token

    assert_response(:redirect)
    assert_redirected_to(:controller => "email", :action => "activated")

    assert_equal(nil, @request.session[:user_id])
    assert_equal(nil, @request.session[:signup_form])
  end

  test "POST activated, abnormal, no activation token" do
    post :activate, :activation_token => nil

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET activate, abnormal, method not allowed" do
    get :activate

    assert_response(405)
    assert_template(nil)
  end

  test "GET activated" do
    get :activated

    assert_response(:success)
    assert_template("activated")
    assert_flash_empty
  end

  test "GET activated, clean session" do
    @request.session[:user_id]     = :dummy
    @request.session[:signup_form] = :dummy

    get :activated

    assert_response(:success)
    assert_template("activated")

    assert_equal(nil, @request.session[:user_id])
    assert_equal(nil, @request.session[:signup_form])
  end
end
