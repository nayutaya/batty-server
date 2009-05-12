
class SignupActivationMailer < ActionMailer::Base
  def request
    subject    "SignupActivationMailer#request"
    recipients "yuyakato@gmail.com"
    from       "batty-no-reply@nayutaya.jp"
    sent_on    Time.now

    body       :greeting => "Hi,"
  end
end
