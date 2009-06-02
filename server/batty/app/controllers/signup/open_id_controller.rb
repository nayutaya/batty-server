# -*- coding: utf-8 -*-

# OpenIDサインアップ
# FIXME: 全体的に実装を整理
class Signup::OpenIdController < ApplicationController
  # GET /signup/open_id
  def index
    session[:identity_url] = nil
    @openid_url = nil
  end

  # POST /signup/open_id/authenticate
  # GET  /signup/open_id/authenticate
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
          redirect_to(:action => "authenticated")
        end
      else raise("BUG")
      end
    }
  end

  # GET /signup/open_id/authenticated
  def authenticated
    @identity_url = session[:identity_url]
  end

  # POST /signup/open_id/create
  def create
    @identity_url = session[:identity_url]

    User.transaction {
      @user = User.new
      @user.user_token = User.create_unique_user_token
      @user.save!

      @credential = OpenIdCredential.new
      @credential.user         = @user
      @credential.identity_url = @identity_url
      # FIXME: ログイン日時を設定しないように変更
      @credential.loggedin_at  = Time.now
      @credential.save!
    }

    # FIXME: ログイン状態にしないように変更
    session[:identity_url] = nil
    session[:user_id]      = @user.id

    redirect_to(:action => "created")
  end

  # GET /signup/open_id/created
  def created
    # nop
  end
end
