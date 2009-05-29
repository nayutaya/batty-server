
# デバイスAPI
class DeviceApiController < ApplicationController
  skip_before_filter :verify_authenticity_token
  verify(
    :method => :post,
    :render => {:text => "Method Not Allowed", :status => 405})
  before_filter :required_param_device_token

  # POST /device/token/:device_token/energies/update/:level
  # POST /device/token/:device_token/energies/update/:level/:time
  def update_energy
    @api_form = UpdateEnergyApiForm.from(params)

    unless @api_form.valid?
      render(:text => "", :status => 422)
      return
    end

    #records = @device.update_energy(@api_form.to_energy_hash.merge(:update_event => true))

    @energy = Energy.new(@api_form.to_energy_hash)
    @energy.device_id = @device.id
    @energy.save!

    # TODO: イベントの生成処理を実装
    # TODO: メールアクションの実行処理を実装
    # TODO: HTTPアクションの実行処理を実装

    render(:text => "success")
  end

  private

  def required_param_device_token(device_token = params[:device_token])
    return super(device_token) {
      render(:text => "Not Found", :status => 404)
    }
  end
end
