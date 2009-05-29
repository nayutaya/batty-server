
# メールアクション実行
class EmailActionExecutor
  def initialize
    @subject    = nil
    @recipients = nil
    @body       = nil
  end

  attr_accessor :subject, :recipients, :body
end
