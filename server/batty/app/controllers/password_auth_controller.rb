
# メールアドレス/パスワード認証
class PasswordAuthController < ApplicationController
  verify(
    :method => :post,
    :render => {:text => "Method Not Allowed", :status => 405},
    :only   => [:login])

  # TODO: URL
  def login
    # TODO: メールアドレスの確認処理を実装
    # TODO: パスワードの確認処理を実装

    credential = EmailCredential.authenticate(params[:email], params[:password])

    if credential
      session[:user_id] = credential.user_id
      # TODO: リダイレクト処理を実装
      redirect_to(:action => "login_complete")
    else
      render
    end
  end

  # TODO: URL
  def login_complete
    # TODO: リダイレクト処理を実装
  end
end
