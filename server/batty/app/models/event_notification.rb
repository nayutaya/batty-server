class EventNotification < ActionMailer::Base
  

  def notify(sent_at = Time.now)
    subject    'EventNotification#notify'
    recipients ''
    from       ''
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end

end
