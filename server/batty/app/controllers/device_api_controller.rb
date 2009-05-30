
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

    Energy.transaction {
      @energy = Energy.new(@api_form.to_energy_hash)
      @energy.device_id = @device.id
      @energy.save!

      # TODO: テスト
      @events = @device.build_events
      @events.each(&:save!)
    }

    # TODO: テスト
    # TODO: 非同期化
    @email_action_executors = @events.map { |event| EmailActionExecutor.build_exectors(event) }.flatten
    @http_action_executors  = @events.map { |event| HttpActionExecutor.build_exectors(event) }.flatten
    @email_action_executors.map(&:execute)
    @http_action_executors.map(&:execute)

    render(:text => "success")
  end

  private

  def required_param_device_token(device_token = params[:device_token])
    return super(device_token) {
      render(:text => "Not Found", :status => 404)
    }
  end
end
