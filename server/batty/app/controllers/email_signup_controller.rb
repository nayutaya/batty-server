
# メールサインアップ
class EmailSignupController < ApplicationController
  # GET /signup/email
  def index
    session[:user_id] = nil
    @signup_form = EmailSignupForm.new
  end

  # POST /signup/email/validate
  # GET /signup/email/validated
  # POST /signup/email/create
  # GET /signup/email/created
  # GET /signup/email/activation/:activation_token
  # POST /signup/email/activate
  # GET /signup/email/activated
end
