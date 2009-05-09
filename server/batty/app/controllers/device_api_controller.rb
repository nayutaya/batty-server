
# デバイスAPI
class DeviceApiController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :required_param_device_token

  # FIXME: POSTメソッドに制限
  # POST /device/:device_token/energies/update/:level
  # POST /device/:device_token/energies/update/:level/:time
  def update_energy
    if params[:level].blank?
      render(:text => "", :status => 404)
      return
    end

    unless /\A\d{1,3}\z/ =~ params[:level]
      render(:text => "", :status => 404)
      return
    end

    unless (0..100).include?(params[:level].to_i)
      render(:text => "", :status => 404)
      return
    end

    @level = params[:level].to_i

    if params[:time].blank?
      @time = Time.now
    else
      unless /\A\d{14}\z/ =~ params[:time]
        render(:text => "", :status => 404)
        return
      end
      begin
        @time = Time.parse(params[:time])
      rescue ArgumentError
        render(:text => "", :status => 404)
        return
      end
    end

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
