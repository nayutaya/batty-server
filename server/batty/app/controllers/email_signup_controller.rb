
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
      # TODO: error flash
      render(:action => "index")
    end
  end

  # GET /signup/email/validated

  # POST /signup/email/create

  # GET /signup/email/created

  # GET /signup/email/activation/:activation_token

  # POST /signup/email/activate

  # GET /signup/email/activated
end
