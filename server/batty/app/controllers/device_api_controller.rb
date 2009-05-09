
# デバイスAPI
class DeviceApiController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :required_param_device_token

  # FIXME: POSTメソッドに制限
  # POST /device/:device_token/energies/update/:level
  # POST /device/:device_token/energies/update/:level/:time
  def update_energy
    # TODO: Energyオブジェクトの生成処理を実装
    # TODO: Triggerオブジェクトの評価処理を実装
    # TODO: Eventオブジェクトの生成処理を実装
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
