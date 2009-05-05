# -*- coding: utf-8 -*-
class OpenIdAuthController < ApplicationController

  # TODO login アクションを実装する
  # TODO logout アクションを実装する

  def login
    openid_url = params[:openid_url]

    authenticate_with_open_id(openid_url) do |result, identity_url, sreg|
      case result.status
      when :missing
        failed_login "OpenID サーバが見つかりませんでした。"
      when :invalid
        failed_login "OpenID が不正です。"
      when :canceled
        failed_login "OpenID の検証がキャンセルされました。"
      when :failed
        failed_login "OpenID の検証が失敗しました。"
      when :successful
        @current_user = OpenIdCredential.find_by_identity_url(identity_url).try(:user)
        if @current_user
          successful_login
        else
          flash[:notice] = 'OpenID がまだ登録されていません。'
          redirect_to :controller => 'open_id_signup', :action => 'signup'
        end
      end
    end
  end

  def logout
    reset_session
    flash[:notice] = 'ログアウトしました。'
    redirect_to root_path
  end

  private

  def successful_login
    session[:user_id] = @current_user.id
    flash[:notice] = 'ログインしました。'
    redirect_to root_path
  end

  def failed_login(message)
    flash[:error] = message
    redirect_to root_path
  end

end
