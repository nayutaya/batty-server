
# アクションメーラユーティリティ
module ActionMailerUtil
  private

  def build_message(options)
    subject(options[:subject])
    from(options[:from])
    recipients(options[:recipients])
    sent_on(Time.now)
    body(options[:body])

    return nil
  end
end
