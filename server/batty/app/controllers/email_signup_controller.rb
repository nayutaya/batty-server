
# メールサインアップ
class EmailSignupController < ApplicationController
  # GET /signup/email
  def index
    session[:user_id] = nil
    @signup_form = EmailSignupForm.new
  end
end
