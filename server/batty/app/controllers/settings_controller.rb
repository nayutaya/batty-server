
# ユーザ設定
class SettingsController < ApplicationController
  before_filter :authentication
  before_filter :authentication_required

  # GET /settings
  def index
    # nop
  end
end
