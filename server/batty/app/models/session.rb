# == Schema Information
# Schema version: 20090529051529
#
# Table name: sessions
#
#  id         :integer       not null, primary key
#  created_at :datetime      not null
#  updated_at :datetime      not null, index_sessions_on_updated_at
#  session_id :string(64)    not null, index_sessions_on_session_id(unique)
#  data       :text
#

# セッション
class Session < ActiveRecord::Base
  def self.cleanup(seconds)
    self.delete_all(["(sessions.updated_at < ?)", Time.now - seconds])
    return nil
  end
end
