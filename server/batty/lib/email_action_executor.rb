
# メールアクション実行
class EmailActionExecutor
  def initialize(options = {})
    options = options.dup
    @subject    = options.delete(:subject)    || nil
    @recipients = options.delete(:recipients) || nil
    @body       = options.delete(:body)       || nil
    raise(ArgumentError) unless options.empty?
  end

  attr_accessor :subject, :recipients, :body

  def execute
    EventNotification.deliver_notify(
      :subject    => self.subject,
      :recipients => self.recipients,
      :body       => self.body)

    return nil
  end
end
