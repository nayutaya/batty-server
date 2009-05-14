
# メールサインアップ
class EmailSignupController < ApplicationController
  # TODO: filter_parameter_logging
  verify(
    :method => :post,
    :render => {:text => "Method Not Allowed", :status => 405},
    :only   => [:validate])

  # GET /signup/email
  def index
    session[:user_id]     = nil
    session[:signup_form] = nil
    @signup_form = EmailSignupForm.new
  end

  # POST /signup/email/validate
  def validate
    session[:user_id]     = nil
    session[:signup_form] = nil
    @signup_form = EmailSignupForm.new(params[:signup_form])

    if @signup_form.valid?
      session[:signup_form] = @signup_form.attributes
      redirect_to(:action => "validated")
    else
      @signup_form.password              = nil
      @signup_form.password_confirmation = nil
      # TODO: error flash
      render(:action => "index")
    end
  end

  # GET /signup/email/validated
  def validated
    # nop
  end

  # POST /signup/email/create
  def create
    redirect_to(:action => "created")
  end

  # GET /signup/email/created
  def created
    # nop
  end

  # GET /signup/email/activation/:activation_token
  def activation
    # nop
  end

  # POST /signup/email/activate
  def activate
    redirect_to(:action => "activated")
  end

  # GET /signup/email/activated
  def activated
    # nop
  end
end
