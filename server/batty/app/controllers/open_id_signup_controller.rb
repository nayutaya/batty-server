# -*- coding: utf-8 -*-

# OpenIDサインアップ
class OpenIdSignupController < ApplicationController

  # GET /signup/openid
  def index
    session[:identity_url] = nil
    @openid_url = nil
  end

  # POST /signup/openid/authenticate
  # GET  /signup/openid/authenticate
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

  # GET /signup/openid/authenticated
  def authenticated
    @identity_url = session[:identity_url]
  end

  # POST /signup/openid/create
  def create
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

    redirect_to(:action => "created")
  end

  # GET /signup/openid/created
  def created
    # nop
  end
end
