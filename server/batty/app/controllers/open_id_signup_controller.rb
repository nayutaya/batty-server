
# OpenIDサインアップ
class OpenIdSignupController < ApplicationController
  # GET ?
  def index
    session[:identity_url] = nil
    @openid_url = nil
  end

  # POST ?
  # GET ?
  def authenticate
    @openid_url = params[:openid_url]

    failed = proc { |message|
      flash[:error] = message
      redirect_to(:action => "index")
    }

    authenticate_with_open_id(@openid_url) { |result, identity_url, sreg|
      case result.status
      when :missing  then failed["OpenID サーバが見つかりませんでした。"]
      when :invalid  then failed["OpenID が不正です。"]
      when :canceled then failed["OpenID の検証がキャンセルされました。"]
      when :failed   then failed["OpenID の検証が失敗しました。"]
      when :successful
        if OpenIdCredential.exists?(:identity_url => identity_url)
          failed["指定されたOpenIDは既に登録されているため、利用できません。"]
        else
          session[:identity_url] = identity_url
          redirect_to(:action => "authenticate_complete")
        end
      else raise("BUG")
      end
    }
  end

  # GET ?
  def authenticate_complete
    @identity_url = session[:identity_url]
  end

  # POST ?
  def signup
    @identity_url = session[:identity_url]

    User.transaction {
      @user = User.new
      @user.user_token = User.create_unique_user_token
      @user.save!

      @credential = OpenIdCredential.new
      @credential.user         = @user
      @credential.identity_url = @identity_url
      @credential.loggedin_at  = Time.now
      @credential.save!
    }

    session[:identity_url] = nil
    session[:user_id]      = @user.id

    redirect_to(:action => "signup_complete")
  end

  # GET ?
  def signup_complete
    # nop
  end
end
