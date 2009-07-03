
# アクションメーラユーティリティ
module ActionMailerUtil
  private

  def build_message(options)
    sent_on(Time.now)
    subject(options[:subject] || raise(ArgumentError))
    from(options[:from] || raise(ArgumentError))
    recipients(options[:recipients] || raise(ArgumentError))
    body(options[:body] || raise(ArgumentError))

    return nil
  end
end
