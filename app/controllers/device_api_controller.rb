
# デバイスAPI
class DeviceApiController < ApplicationController
  skip_before_filter :verify_authenticity_token
  verify_method_post
  before_filter :required_param_device_token

  # POST /device/token/:device_token/energies/update/:level
  # POST /device/token/:device_token/energies/update/:level/:time
  def update_energy
    @api_form = UpdateEnergyApiForm.from(params)

    unless @api_form.valid?
      render(:text => "", :status => 422)
      return
    end

    Energy.transaction {
      @energy = @device.energies.build(@api_form.to_energy_hash)
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

    # TODO: テスト
    # TODO: 非同期化
    Energy.cleanup(@device, 200)
    Event.cleanup(@device, 100)

    render(:text => "success")
  end

  private

  def required_param_device_token(device_token = params[:device_token])
    return super(device_token) {
      render(:text => "Not Found", :status => 404)
    }
  end
end
