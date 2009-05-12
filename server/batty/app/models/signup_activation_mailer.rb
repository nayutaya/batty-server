
class SignupActivationMailer < ActionMailer::Base
  def request(to)
    subject    "SignupActivationMailer#request"
    recipients to
    from       "batty-no-reply@nayutaya.jp"
    sent_on    Time.now

    body       :greeting => "Hi,"
  end
end
