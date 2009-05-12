
# ホーム
class HomeController < ApplicationController
  # GET /
  def index
    @login_user = User.find_by_id(session[:user_id])

    if @login_user
      @devices = @login_user.devices.all(:order => "devices.name ASC")
    end
  end
end
