
# ユーザ設定
class SettingsController < ApplicationController
  in_place_edit_for :user, :nickname
  before_filter :authentication
  before_filter :authentication_required

  # GET /settings
  def index
    @user = @login_user
  end
end
