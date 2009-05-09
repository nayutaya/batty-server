
# デバイスAPI
class DeviceApiController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :required_param_device_token

  # FIXME: POSTメソッドに制限
  # POST /device/:device_token/energies/update/:level
  # POST /device/:device_token/energies/update/:level/:time
  def update_energy
    level_str = params[:level]
    time_str  = params[:time]
    time_str  = Time.now.strftime("%Y%m%d%H%M%S") if time_str.blank?

    level_valid   = !level_str.blank?
    level_valid &&= (/\A\d{1,3}\z/ =~ level_str)
    level_valid &&= (0..100).include?(level_str.to_i)

    time_valid   = !time_str.blank?
    time_valid &&= (/\A\d{14}\z/ =~ time_str)
    time_valid &&= (Time.parse(time_str) rescue false)

    unless level_valid && time_valid
      render(:text => "", :status => 404)
      return
    end

    @level = level_str.to_i
    @time  = Time.parse(time_str)

    @device.update_energy(
      :observed_level => @level,
      :observed_at    => @time,
      :update_event   => true)

    render(:text => "success")
  end

  private

  def required_param_device_token(device_token = params[:device_token])
    @device = Device.find_by_device_token(device_token)
    return true if @device

    render(:text => "", :status => 404)

    return false
  end
end
