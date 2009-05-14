
class SignupActivationMailer < ActionMailer::Base
  self.default_url_options[:host] = "localhost"

  def self.create_request_params(options)
    options = options.dup
    recipients     = options.delete(:recipients)     || raise(ArgumentError)
    activation_url = options.delete(:activation_url) || raise(ArgumentError)
    raise(ArgumentError) unless options.empty?

    return {
      :header => {
        :subject    => "[batty] ユーザ登録",
        :from       => "batty-no-reply@nayutaya.jp",
        :recipients => recipients,
      },
      :body   => {
        :activation_url => activation_url,
      },
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
end
