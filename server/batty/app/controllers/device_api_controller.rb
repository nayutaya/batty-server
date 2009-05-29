
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

    records = @device.update_energy(@api_form.to_energy_hash.merge(:update_event => true))

    # TODO: テストを記述
    @email_actions = []
    records.each { |record|
      trigger = record[:trigger]
      @email_actions += trigger.email_actions.enable.map { |email_action| record.dup.merge(:email_action => email_action) }
      # TODO: HttpAction
    }

    # TODO: テストを記述
    @notify_mails = @email_actions.map { |info|
      email_action = info[:email_action]
      {
        :subject    => email_action.subject,
        :recipients => "mr.yu-yan.free@docomo.ne.jp",
        :body       => email_action.body,
      }
    }

    # TODO: テストを記述
    # TODO: 非同期化
    begin
      @notify_mails.each { |notify_mail|
        EventNotification.deliver_notify(notify_mail)
      }
    rescue Exception => e
      logger.add(
        logger.class::ERROR,
        format("%s\n%s: %s\n%s\n%s", "-" * 50, e.class.name, e.message, e.backtrace[0, 5].join("\n"), "-" * 50))
    end

    render(:text => "success")
  end

  private

  def required_param_device_token(device_token = params[:device_token])
    return super(device_token) {
      render(:text => "Not Found", :status => 404)
    }
  end
end
