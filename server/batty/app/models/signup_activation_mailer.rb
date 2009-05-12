class SignupActivationMailer < ActionMailer::Base
  

  def request(sent_at = Time.now)
    subject    'SignupActivationMailer#request'
    recipients ''
    from       ''
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end

end
