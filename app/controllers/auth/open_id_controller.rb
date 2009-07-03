# -*- coding: utf-8 -*-

# OpenID認証
# FIXME: 全体的に実装を整理
class Auth::OpenIdController < ApplicationController
  verify_method_post :only => [:login]

  # GET /auth/open_id
  def index
    session[:user_id] = nil
  end

  # POST /auth/open_id/login
  # GET  /auth/open_id/login
  def login
    openid_url = params[:openid_url]

    authenticate_with_open_id(openid_url) { |result, identity_url, sreg|
      if result.successful?
        @open_id_credential = OpenIdCredential.find_by_identity_url(identity_url)
        if @open_id_credential
          @open_id_credential.login!
          session[:user_id] = @open_id_credential.user.id
          flash[:notice] = "ログインしました。"
          redirect_to(root_path)
        else
          flash[:notice] = "OpenID がまだ登録されていません。"
          redirect_to(:controller => "signup/open_id", :action => "index")
        end
      else
        failed_login(result.message)
      end
    }
  end

  private

  def failed_login(message)
    flash[:error] = message
    redirect_to(root_path)
  end

end
