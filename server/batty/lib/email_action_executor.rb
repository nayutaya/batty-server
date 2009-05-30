
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

  def self.from(email_action)
    return self.new(
      :subject    => email_action.subject,
      :recipients => email_action.email,
      :body       => email_action.body)
  end

  def replace(keywords)
    subject = NoticeFormatter.replace_keywords(self.subject, keywords) if self.subject
    body    = NoticeFormatter.replace_keywords(self.body,    keywords) if self.body
    return self.class.new(
      :subject    => subject,
      :recipients => self.recipients,
      :body       => body)
  end

  def execute
    EventNotification.deliver_notify(
      :subject    => self.subject,
      :recipients => self.recipients,
      :body       => self.body)

    return nil
  end
end
