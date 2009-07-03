
require 'test_helper'

class Credentials::OpenIdControllerTest < ActionController::TestCase
  def setup
    @yuya           = users(:yuya)
    @yuya_livedoor  = open_id_credentials(:yuya_livedoor)
    @shinya_example = open_id_credentials(:shinya_example)

    @login_form = OpenIdLoginForm.new(
      :openid_url => "livedoor.com")

    session_login(@yuya)
  end

  test "routes" do
    base = {:controller => "credentials/open_id"}

    assert_routing("/credentials/open_id/new",    base.merge(:action => "new"))
    assert_routing("/credentials/open_id/create", base.merge(:action => "create"))

    assert_routing("/credential/open_id/1234567890/delete",  base.merge(:action => "delete",  :open_id_credential_id => "1234567890"))
    assert_routing("/credential/open_id/1234567890/destroy", base.merge(:action => "destroy", :open_id_credential_id => "1234567890"))
  end

  test "GET new" do
    get :new

    assert_response(:success)
    assert_template("new")
    assert_flash_empty
    assert_logged_in(@yuya)

    assert_equal(
      OpenIdLoginForm.new.attributes,
      assigns(:login_form).attributes)
  end

  test "GET new, abnormal, no login" do
    session_logout

    get :new

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  # MEMO: 実際にエンドポイントにアクセスに行く（インターネットへのアクセスが発生）
  test "POST create(begin)" do
    musha = Kagemusha.new(ActionController::Base).
      def(:open_id_redirect_url) { "http://openid/providor" }

    musha.swap {
      post :create, :login_form => @login_form.attributes
    }

    assert_response(:redirect)
    assert_redirected_to("http://openid/providor")
    assert_flash_empty
    assert_logged_in(@yuya)

    assert_equal(@login_form.attributes, assigns(:login_form).attributes)
    assert_equal(nil, assigns(:status))
  end

  test "POST create(begin), invalid form" do
    @login_form.openid_url = nil

    post :create, :login_form => @login_form.attributes

    assert_response(:success)
    assert_template("new")
    assert_flash_error
  end

  test "POST create(begin), result is invalid" do
    musha = Kagemusha.new(ActionController::Base).
      def(:normalize_identifier) { raise(OpenIdAuthentication::InvalidOpenId) }

    musha.swap {
      post :create, :login_form => @login_form.attributes
    }

    assert_response(:success)
    assert_template("new")
    assert_flash_error

    assert_equal(:invalid, assigns(:status))
  end

  test "POST create(begin), result is missing" do
    musha = Kagemusha.new(ActionController::Base).
      def(:normalize_identifier) { raise(OpenID::OpenIDError) }

    musha.swap {
      post :create, :login_form => @login_form.attributes
    }

    assert_response(:success)
    assert_template("new")
    assert_flash_error

    assert_equal(:missing, assigns(:status))
  end

  test "GET create(complete)" do
    identity_url = "http://openid/"
    musha = create_openid_musha(identity_url, OpenID::Consumer::SUCCESS)

    assert_difference("OpenIdCredential.count", +1) {
      musha.swap {
        get :create, :open_id_complete => "1"
      }
    }

    assert_response(:redirect)
    assert_redirected_to(:controller => "/credentials", :action => "index")
    assert_flash_notice

    assert_equal(:successful, assigns(:status))

    assigns(:open_id_credential).reload
    assert_equal(@yuya.id,     assigns(:open_id_credential).user_id)
    assert_equal(identity_url, assigns(:open_id_credential).identity_url)
  end

  test "GET create(complete), already exists" do
    identity_url = open_id_credentials(:yuya_livedoor).identity_url
    musha = create_openid_musha(identity_url, OpenID::Consumer::SUCCESS)

    musha.swap {
      get :create, :open_id_complete => "1"
    }

    assert_response(:success)
    assert_template("new")
    assert_flash_error

    assert_equal(identity_url, assigns(:login_form).openid_url)
    assert_equal(:successful, assigns(:status))
  end

  test "GET create(complete), result is canceled" do
    identity_url = "http://openid/"
    musha = create_openid_musha(identity_url, OpenID::Consumer::CANCEL)

    musha.swap {
      get :create, :open_id_complete => "1"
    }

    assert_response(:success)
    assert_template("new")
    assert_flash_error

    assert_equal(identity_url, assigns(:login_form).openid_url)
    assert_equal(:canceled, assigns(:status))
  end

  test "GET create(complete), result is failed" do
    musha = create_openid_musha("http://openid/", OpenID::Consumer::FAILURE)

    musha.swap {
      get :create, :open_id_complete => "1"
    }

    assert_response(:success)
    assert_template("new")
    assert_flash_error

    assert_equal(:failed, assigns(:status))
  end

  test "GET create(complete), result is setup needed" do
    musha = create_openid_musha("http://openid/", OpenID::Consumer::SETUP_NEEDED)

    musha.swap {
      get :create, :open_id_complete => "1"
    }

    assert_response(:success)
    assert_template("new")
    assert_flash_error

    assert_equal(:setup_needed, assigns(:status))
  end

  test "POST create, abnormal, no login" do
    session_logout

    post :create

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET delete" do
    get :delete, :open_id_credential_id => @yuya_livedoor.id

    assert_response(:success)
    assert_template("delete")
    assert_flash_empty
    assert_logged_in(@yuya)

    assert_equal(@yuya_livedoor, assigns(:open_id_credential))
  end

  test "GET delete, abnormal, no login" do
    session_logout

    get :delete, :open_id_credential_id => @yuya_livedoor.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET delete, abnormal, invalid openid credential id" do
    get :delete, :open_id_credential_id => "0"

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "GET delete, abnormal, other's openid credential" do
    get :delete, :open_id_credential_id => @shinya_example.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST destroy" do
    assert_difference("OpenIdCredential.count", -1) {
      post :destroy, :open_id_credential_id => @yuya_livedoor.id
    }

    assert_response(:redirect)
    assert_redirected_to(:controller => "/credentials", :action => "index")
    assert_flash_notice
    assert_logged_in(@yuya)

    assert_equal(@yuya_livedoor, assigns(:open_id_credential))

    assert_equal(nil, OpenIdCredential.find_by_id(@yuya_livedoor.id))
  end

  test "GET destroy, abnormal, method not allowed" do
    get :destroy, :open_id_credential_id => @yuya_livedoor.id

    assert_response(405)
    assert_template(nil)
  end

  test "POST destroy, abnormal, no login" do
    session_logout

    post :destroy, :open_id_credential_id => @yuya_livedoor.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST destroy, abnormal, invalid openid credential id" do
    post :destroy, :open_id_credential_id => "0"

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  test "POST destroy, abnormal, other's openid credential" do
    post :destroy, :open_id_credential_id => @shinya_example.id

    assert_response(:redirect)
    assert_redirected_to(root_path)
    assert_flash_error
  end

  private

  def create_openid_musha(identity_url, status)
    composite = Kagemusha::Composite.new

    composite << Kagemusha.new(ActionController::Base).
      def(:timeout_protection_from_identity_server) {
        obj = Object.new
        meta = (class << obj; self; end)
        meta.__send__(:define_method, :display_identifier) { identity_url }
        meta.__send__(:define_method, :status) { status }
        meta.__send__(:define_method, :setup_url) { nil }
        obj
      }

    composite << Kagemusha.new(OpenID::SReg::Response).
      defs(:from_success_response) { nil }

    composite << Kagemusha.new(OpenID::AX::FetchResponse).
      defs(:from_success_response) { nil }

    return composite
  end
end
