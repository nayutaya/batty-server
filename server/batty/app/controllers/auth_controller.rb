
# 認証
class AuthController < ApplicationController
  # GET ?
  def login_complete
    @return_path = params[:return_path]
    @return_path = root_path if @return_path.blank?
  end

  # POST ?
  def logout
    reset_session
    redirect_to(root_path)
  end
end
