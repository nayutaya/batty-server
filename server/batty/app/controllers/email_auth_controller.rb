
class EmailAuthController < ApplicationController
  # GET auth/email
  def index
    session[:user_id] = nil
    @login_form = EmailLoginForm.new
  end

  # POST auth/email/login
  def login
    session[:user_id] = nil
    @login_form = EmailLoginForm.new(params[:login_form])

    if @login_form.valid?
      @email_credential = @login_form.authenticate
    end

    if @email_credential
      @login_user = @email_credential.user
      session[:user_id] = @login_user.id
      redirect_to(:controller => "auth", :action => "login_complete")
    else
      set_error_now("メールアドレス、またはパスワードが違います。")
      render(:action => "index")
    end
  end

  private

  def set_error_now(message)
    flash.now[:notice] = @flash_notice = nil
    flash.now[:error]  = @flash_error  = message
  end
end
