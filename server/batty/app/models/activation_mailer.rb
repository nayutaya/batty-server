
# アクティベーションメーラ
class ActivationMailer < ActionMailer::Base
  include ActionMailerUtil

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
