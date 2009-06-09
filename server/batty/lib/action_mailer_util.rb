
# アクションメーラユーティリティ
module ActionMailerUtil
  private

  def build_message(options)
    header = options[:header] || {}
    body   = options[:body]   || {}

    subject(header[:subject])
    from(header[:from])
    recipients(header[:recipients])
    sent_on(Time.now)
    body(body)

    return nil
  end
end
