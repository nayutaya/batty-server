
# メールアドレス/パスワードサインアップ
class PasswordSignupController < ApplicationController
  # GET ?
  def index
    @credential = EmailCredential.new
  end

  # POST ?
  def confirm
    @credential = EmailCredential.new
    @credential.attributes = params[:credential]

    @credential.activation_token = EmailCredential.create_unique_activation_token
    @credential.hashed_password  = EmailCredential.create_hashed_password(@credential.password.to_s)

    if @credential.valid?
      session[:email_credential] = params[:credential]
    else
      flash.now[:error] = "内容を確認してください。"
      render(:action => "index")
    end
  end

  def signup
  end
end
