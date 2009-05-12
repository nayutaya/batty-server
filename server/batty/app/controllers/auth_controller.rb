
# 認証
class AuthController < ApplicationController
  # GET ?
  def login_complete
    @return_path = params[:return_path]
    @return_path = root_path if @return_path.blank?
  end
end
