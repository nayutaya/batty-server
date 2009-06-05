
# セッション
class Session < ActiveRecord::Base
  def self.cleanup(seconds)
    self.delete_all(["(sessions.updated_at < ?)", Time.now - seconds])
    return nil
  end
end
