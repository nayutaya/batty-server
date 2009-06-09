
# アクティベーションメーラ
class ActivationMailer < ActionMailer::Base
=begin
  def request_for_notice(sent_at = Time.now)
    subject    'ActivationMailer#request_for_notice'
    recipients ''
    from       ''
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end
=end

  def build_message(options)
    subject(options[:header][:subject])
    from(options[:header][:from])
    recipients(options[:header][:recipients])
    sent_on(Time.now)
    body(options[:body])

    return nil
  end
end
