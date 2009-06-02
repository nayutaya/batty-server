
# 認証
class AuthController < ApplicationController
  verify_method_post :only => [:logout]

  # GET /auth/login_complete
  def login_complete
    @return_path = params[:return_path]
    @return_path = root_path if @return_path.blank?
  end

  # POST /auth/logout
  def logout
    reset_session
    redirect_to(:action => "logout_complete")
  end

  # GET /logout_complete
  def logout_complete
    @return_path = params[:return_path]
    @return_path = root_path if @return_path.blank?
  end
end
