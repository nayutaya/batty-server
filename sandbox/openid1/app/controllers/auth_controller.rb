
class AuthController < ApplicationController
  def index
  end

  def login
    openid_url = (params[:session] || {})[:openid_url]

    authenticate_with_open_id(openid_url) do |result, identity_url, sreg|
      if result.successful?
        flash.now[:notice] = "ログインに成功 #{identity_url}"
      else
        flash.now[:notice] = "ログインに失敗 #{result.message}"
      end
    end
  end
end
