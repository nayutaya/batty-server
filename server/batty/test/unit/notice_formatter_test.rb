
require 'test_helper'

class NoticeFormatterTest < ActiveSupport::TestCase
  def setup
    @module = NoticeFormatter
  end

  test "format_date" do
    expected = {
      "date"      => "2009-01-02",
      "date:json" => '"2009-01-02"',
      "date:ja"   => "2009年01月02日",
      "yyyy"      => "2009",
      "mm"        => "01",
      "dd"        => "02",
    }
    assert_equal(expected, @module.format_date(Date.new(2009, 1, 2)))
  end

  test "format_date, nil" do
    expected = {
      "date"      => "-",
      "date:json" => "null",
      "date:ja"   => "-",
      "yyyy"      => "-",
      "mm"        => "-",
      "dd"        => "-",
    }
    assert_equal(expected, @module.format_date(nil))
  end

  test "format_time" do
    expected = {
      "time"      => "01:02:03",
      "time:json" => '"01:02:03"',
      "time:ja"   => "01時02分03秒",
      "hh"        => "01",
      "nn"        => "02",
      "ss"        => "03",
    }
    assert_equal(expected, @module.format_time(Time.local(2009, 12, 31, 1, 2, 3)))
  end

  test "format_time, nil" do
    expected = {
      "time"      => "-",
      "time:json" => "null",
      "time:ja"   => "-",
      "hh"        => "-",
      "nn"        => "-",
      "ss"        => "-",
    }
    assert_equal(expected, @module.format_time(nil))
  end

  test "format_datetime" do
    datetime = Time.local(2009, 12, 31, 12, 34, 56)
    expected = {
      "datetime"      => "2009-12-31 12:34:56",
      "datetime:json" => '"2009-12-31 12:34:56"',
      "datetime:ja"   => "2009年12月31日 12時34分56秒",
    }
    expected.merge!(@module.format_date(datetime))
    expected.merge!(@module.format_time(datetime))
    assert_equal(expected, @module.format_datetime(datetime))
  end

  test "format_datetime, nil" do
    expected = {
      "datetime"      => "-",
      "datetime:json" => "null",
      "datetime:ja"   => "-",
    }
    expected.merge!(@module.format_date(nil))
    expected.merge!(@module.format_time(nil))
    assert_equal(expected, @module.format_datetime(nil))
  end

  test "format_integer_value" do
    assert_equal("1", @module.format_integer_value(1))
    assert_equal("-", @module.format_integer_value(nil))
  end

  test "format_integer_json_value" do
    assert_equal("1", @module.format_integer_json_value(1))
    assert_equal("null", @module.format_integer_json_value(nil))
  end
end
