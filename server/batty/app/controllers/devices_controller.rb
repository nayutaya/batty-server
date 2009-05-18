
# デバイス
class DevicesController < ApplicationController
  before_filter :authentication, :only => [:show]
  before_filter :authentication_required, :only => [:show]
  before_filter :required_param_device_token, :only => [:show]

  # GET /devices/new

  # POST /devices/create

  # GET /device/:device_token
  def show
    @energies = @device.energies.paginate(
      :order    => "energies.observed_at DESC, energies.id DESC",
      :page     => 1,
      :per_page => 10)
    @events = @device.events.paginate(
      :order    => "events.observed_at DESC, events.id DESC",
      :page     => 1,
      :per_page => 10)
  end

  private

  def authentication(user_id = session[:user_id])
    @login_user = User.find_by_id(user_id)
    return true
  end

  def authentication_required
    return true if @login_user

    set_error("ログインが必要です。")
    redirect_to(root_path)

    return false
  end

  def required_param_device_token(device_token = params[:device_token])
    @device = Device.find_by_device_token(device_token)
    return true if @device

    set_error("デバイストークンが正しくありません。")
    redirect_to(root_path)

    return false
  end
end
