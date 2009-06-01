
# 通知先メールアドレスアクティベーションメーラ
class EmailActivationMailer < ActionMailer::Base
  FromAddress = "batty-no-reply@nayutaya.jp"

  def self.create_request_params(options)
    options = options.dup
    recipients     = options.delete(:recipients)     || raise(ArgumentError)
    activation_url = options.delete(:activation_url) || raise(ArgumentError)
    raise(ArgumentError) unless options.empty?

    return {
      :header => {
        :subject    => "[batty] 通知先メールアドレス登録",
        :from       => FromAddress,
        :recipients => recipients,
      },
      :body   => {
        :activation_url => activation_url,
      },
    }
  end

  def self.create_complete_params(options)
    options = options.dup
    recipients = options.delete(:recipients) || raise(ArgumentError)
    raise(ArgumentError) unless options.empty?

    return {
      :header => {
        :subject    => "[batty] 通知先メールアドレス登録完了",
        :from       => FromAddress,
        :recipients => recipients,
      },
      :body   => {},
    }
  end

  def request(options)
    params = self.class.create_request_params(options)
    subject(params[:header][:subject])
    from(params[:header][:from])
    recipients(params[:header][:recipients])
    sent_on(Time.now)
    body(params[:body])
  end

  def complete(options)
    params = self.class.create_complete_params(options)
    subject(params[:header][:subject])
    from(params[:header][:from])
    recipients(params[:header][:recipients])
    sent_on(Time.now)
    body(params[:body])
  end
end
