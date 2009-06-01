class EmailActivationMailer < ActionMailer::Base
  

  def request(sent_at = Time.now)
    subject    'EmailActivationMailer#request'
    recipients ''
    from       ''
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end

  def complete(sent_at = Time.now)
    subject    'EmailActivationMailer#complete'
    recipients ''
    from       ''
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end

end
