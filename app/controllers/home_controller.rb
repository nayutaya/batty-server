
# ホーム
class HomeController < ApplicationController
  before_filter :authentication

  # GET /
  def index
    if @login_user
      @devices  = @login_user.devices.all(
        :order => "devices.name ASC, devices.id ASC")
      @energies = @login_user.energies.paginate(
        :include  => [:device],
        :order    => "energies.observed_at DESC, energies.id DESC",
        :page     => 1,
        :per_page => 10)
      @events   = @login_user.events.paginate(
        :include  => [:device],
        :order    => "events.observed_at DESC, events.id DESC",
        :page     => 1,
        :per_page => 10)
    end
  end
end
