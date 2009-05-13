
class EmailAuthController < ApplicationController
  # GET auth/email
  def index
    session[:user_id] = nil
    @login_form = EmailLoginForm.new
  end

  # POST auth/email/login
  def login
    @login_form = EmailLoginForm.new(params[:login_form])

    if @login_form.valid?
      @email_credential = @login_form.authenticate
    end

    if @email_credential
      # TODO: session
      redirect_to(:controller => "auth", :action => "login_complete")
    else
      set_error_now("メールアドレス、またはパスワードが違います。")
      render(:action => "index")
    end
  end

  private

  def set_error_now(message)
    flash.now[:error] = @flash_error = message
  end
end
