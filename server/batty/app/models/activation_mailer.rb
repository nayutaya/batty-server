
# アクティベーションメーラ
class ActivationMailer < ActionMailer::Base
  include ActionMailerUtil

  SubjectPrefix = "[batty] "
  FromAddress   = "batty-no-reply@nayutaya.jp"

  def self.create_request_for_notice_params(options)
    options = options.dup
    recipients     = options.delete(:recipients)     || raise(ArgumentError)
    activation_url = options.delete(:activation_url) || raise(ArgumentError)
    raise(ArgumentError) unless options.empty?

    return {
      :header => {
        :subject    => SubjectPrefix + "通知先メールアドレス登録",
        :from       => FromAddress,
        :recipients => recipients,
      },
      :body   => {
        :activation_url => activation_url,
      },
    }
  end

=begin
  def request_for_notice(sent_at = Time.now)
    subject    'ActivationMailer#request_for_notice'
    recipients ''
    from       ''
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end
=end
end
