
# デバイスAPI
class DeviceApiController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :required_param_device_token

  verify(
    :method => :post,
    :render => {:text => "Method Not Allowed", :status => 405})

  # POST /device/token/:device_token/energies/update/:level
  # POST /device/token/:device_token/energies/update/:level/:time
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

    records = @device.update_energy(
      :observed_level => @level,
      :observed_at    => @time,
      :update_event   => true)

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
