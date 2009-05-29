
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
end
