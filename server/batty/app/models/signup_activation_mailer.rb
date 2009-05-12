
class SignupActivationMailer < ActionMailer::Base
  def request(recipient)
    subject("[batty] ユーザ登録")
    from("batty-no-reply@nayutaya.jp")
    recipients(recipient)
    sent_on(Time.now)

    activation_url = "http://batty/activation"

    body(:activation_url => activation_url)
  end
end
