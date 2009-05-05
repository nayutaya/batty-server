
# デバイスAPI
class DeviceApiController < ApplicationController
  skip_before_filter :verify_authenticity_token

  # FIXME: POSTメソッドに制限
  # POST /device/:device_token/energies/update/:level
  # POST /device/:device_token/energies/update/:level/:time
  def update_energy
    # TODO: Energyオブジェクトの生成処理を実装
    # TODO: Triggerオブジェクトの評価処理を実装
    # TODO: Eventオブジェクトの生成処理を実装
    render(:text => "update_energy")
  end
end
