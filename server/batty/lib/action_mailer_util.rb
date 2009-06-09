
module ActionMailerUtil
  private

  def build_message(options)
    subject(options[:header][:subject])
    from(options[:header][:from])
    recipients(options[:header][:recipients])
    sent_on(Time.now)
    body(options[:body])

    return nil
  end
end
