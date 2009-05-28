
require 'test_helper'

class NoticeFormatterTest < ActiveSupport::TestCase
  def setup
    @module = NoticeFormatter
  end

  test "format_date" do
    expected = {
      "date"    => "2009-01-02",
      "date:ja" => "2009年01月02日",
      "yyyy"    => "2009",
      "mm"      => "01",
      "dd"      => "02",
    }
    assert_equal(expected, @module.format_date(Date.new(2009, 1, 2)))
  end

  test "format_time" do
    expected = {
      "time"    => "01:02:03",
      "time:ja" => "01時02分03秒",
      "hh"      => "01",
      "nn"      => "02",
      "ss"      => "03",
    }
    assert_equal(expected, @module.format_time(Time.local(2009, 12, 31, 1, 2, 3)))
  end
end
