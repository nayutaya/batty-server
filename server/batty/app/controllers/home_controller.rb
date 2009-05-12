
# ホーム
class HomeController < ApplicationController
  before_filter :authenticate

  # GET /
  def index
    if @login_user
      @devices  = @login_user.devices.all(:order => "devices.name ASC, devices.id ASC")
      @energies = @login_user.energies.paginate(:order => "energies.observed_at DESC, energies.id DESC", :page => 1, :per_page => 10)
      @events   = @login_user.events.paginate(:order => "events.observed_at DESC, events.id DESC", :page => 1, :per_page => 10)
    end
  end

  private

  def authenticate(user_id = session[:user_id])
    @login_user = User.find_by_id(user_id)
    return true
  end
end
