
# イベント通知メール
class EventNotification < ActionMailer::Base
  def self.create_notify_params(options)
    options = options.dup
    subject    = options.delete(:subject)    || raise(ArgumentError)
    recipients = options.delete(:recipients) || raise(ArgumentError)
    body       = options.delete(:body)       || raise(ArgumentError)
    raise(ArgumentError) unless options.empty?

    return {
      :header => {
        :subject    => subject,
        :from       => "batty-no-reply@nayutaya.jp",
        :recipients => recipients,
      },
      :body   => {
        :body => body,
      },
    }
  end

  def notify(options)
    params = self.class.create_notify_params(options)
    subject(params[:header][:subject])
    from(params[:header][:from])
    recipients(params[:header][:recipients])
    sent_on(Time.now)
    body(params[:body])
  end
end
