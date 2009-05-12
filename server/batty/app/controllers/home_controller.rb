
# ホーム
class HomeController < ApplicationController
  before_filter :authenticate

  # GET /
  def index
    if @login_user
      @devices = @login_user.devices.all(:order => "devices.name ASC")
    end
  end

  private

  def authenticate(user_id = session[:user_id])
    @login_user = User.find_by_id(user_id)
    return true
  end
end
