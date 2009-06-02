
# 認証
class AuthController < ApplicationController
  verify_method_post :only => [:logout]

  # GET /auth/login_complete
  # FIXME: アクション名をlogged_inに変更
  def login_complete
    @return_path = params[:return_path]
    @return_path = root_path if @return_path.blank?
  end

  # POST /auth/logout
  def logout
    reset_session
    redirect_to(:action => "logout_complete")
  end

  # GET /auth/logout_complete
  # FIXME: アクション名をlogged_outに変更
  def logout_complete
    @return_path = params[:return_path]
    @return_path = root_path if @return_path.blank?
  end
end
