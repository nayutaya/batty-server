
class HomeController < ApplicationController
  # GET /
  def index
    @user = User.find_by_nickname('yu-yan')
    @devices = @user.devices.sort_by(&:name)
  end
end
