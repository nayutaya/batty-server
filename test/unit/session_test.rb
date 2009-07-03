
require 'test_helper'

class SessionTest < ActiveSupport::TestCase
  def setup
    @klass  = Session
    @record = @klass.new
  end

  #
  # クラスメソッド
  #

  test "self.cleanup, 1 hour" do
    session_a = create_empty_session(Time.local(2009, 1, 1, 11, 59, 59), "a")
    session_b = create_empty_session(Time.local(2009, 1, 1, 12,  0,  0), "b")
    session_c = create_empty_session(Time.local(2009, 1, 1, 12,  0,  1), "c")

    assert_difference("Session.count", -1) {
      Kagemusha::DateTime.at(2009, 1, 1, 13, 0, 0) {
        assert_equal(nil, @klass.cleanup(1.hour))
      }
    }

    assert_nil(@klass.find_by_id(session_a.id))
    assert_not_nil(@klass.find_by_id(session_b.id))
    assert_not_nil(@klass.find_by_id(session_c.id))
  end

  test "self.cleanup, 2 hours" do
    session_a = create_empty_session(Time.local(2009, 12, 31, 0, 30, 29), "a")
    session_b = create_empty_session(Time.local(2009, 12, 31, 0, 30, 30), "b")
    session_c = create_empty_session(Time.local(2009, 12, 31, 0, 30, 31), "c")

    assert_difference("Session.count", -1) {
      Kagemusha::DateTime.at(2009, 12, 31, 2, 30, 30) {
        assert_equal(nil, @klass.cleanup(2.hours))
      }
    }

    assert_nil(@klass.find_by_id(session_a.id))
    assert_not_nil(@klass.find_by_id(session_b.id))
    assert_not_nil(@klass.find_by_id(session_c.id))
  end

  private

  def create_empty_session(time, key)
    return Kagemusha::DateTime.at(time) {
      Session.create!(:session_id => key, :data => "")
    }
  end
end
