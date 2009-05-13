
class EmailAuthController < ApplicationController
  # GET auth/email
  def index
    @login_form = EmailLoginForm.new
  end

  # POST auth/email/login
  # TODO: ログイン処理を実装
end
