
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
end
