
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
    @email_action_executors = []
    @http_action_executors  = []
    @events.each { |event|
      trigger = event.trigger
      trigger.email_actions.enable.each { |email_action|
        @email_action_executors << EmailActionExecutor.new(
          :subject    => email_action.subject,
          :recipients => email_action.email,
          :body       => email_action.body)
      }
      trigger.http_actions.enable.each { |http_action|
        @http_action_executors << HttpActionExecutor.new(
          :url         => http_action.url,
          :http_method => http_action.http_method.downcase.to_sym,
          :post_body   => http_action.body)
      }
    }
    #p @email_action_executors
    #p @http_action_executors

    render(:text => "success")
  end

  private

  def required_param_device_token(device_token = params[:device_token])
    return super(device_token) {
      render(:text => "Not Found", :status => 404)
    }
  end
end
