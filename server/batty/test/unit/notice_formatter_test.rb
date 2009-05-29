
require 'test_helper'

class NoticeFormatterTest < ActiveSupport::TestCase
  def setup
    @module = NoticeFormatter
  end

  test "add_name" do
    expected = {
      "name:a" => "b",
      "name:c" => "d",
    }
    assert_equal(expected, @module.add_name("name", {"a" => "b", "c" => "d"}))
  end

  test "format_integer_value" do
    assert_equal("1", @module.format_integer_value(1))
    assert_equal("-", @module.format_integer_value(nil))
  end

  test "format_integer_json_value" do
    assert_equal("1", @module.format_integer_json_value(1))
    assert_equal("null", @module.format_integer_json_value(nil))
  end

  test "format_string_value" do
    assert_equal("a", @module.format_string_value("a"))
    assert_equal("-", @module.format_string_value(""))
    assert_equal("-", @module.format_string_value(nil))
  end

  test "format_string_json_value" do
    assert_equal('"a"', @module.format_string_json_value("a"))
    assert_equal("null", @module.format_string_json_value(""))
    assert_equal("null", @module.format_string_json_value(nil))
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

  test "format_user" do
    expected = {
      "user:token"         => "0" * User::TokenLength,
      "user:token:json"    => '"' + "0" * User::TokenLength + '"',
      "user:nickname"      => "nickname",
      "user:nickname:json" => '"nickname"',
    }
    user = User.new(
      :user_token => "0" * User::TokenLength,
      :nickname   => "nickname")
    assert_equal(expected, @module.format_user(user))
  end

  test "format_user, nil" do
    expected = {
      "user:token"         => "-",
      "user:token:json"    => "null",
      "user:nickname"      => "-",
      "user:nickname:json" => "null",
    }
    assert_equal(expected, @module.format_user(User.new))
    assert_equal(expected, @module.format_user(nil))
  end

  test "format_device" do
    expected = {
      "device:token"      => "0" * Device::TokenLength,
      "device:token:json" => '"' + "0" * Device::TokenLength + '"',
      "device:name"       => "name",
      "device:name:json"  => '"name"',
    }
    device = Device.new(
      :device_token => "0" * Device::TokenLength,
      :name         => "name")
    assert_equal(expected, @module.format_device(device))
  end

  test "format_device, nil" do
    expected = {
      "device:token"      => "-",
      "device:token:json" => "null",
      "device:name"       => "-",
      "device:name:json"  => "null",
    }
    assert_equal(expected, @module.format_device(Device.new))
    assert_equal(expected, @module.format_device(nil))
  end

  test "format_event" do
    event = Event.new(
      :created_at       => Time.local(2000, 1, 2, 3, 4, 5),
      :trigger_operator => Trigger.operator_symbol_to_code(:eq),
      :trigger_level    => 1,
      :observed_level   => 2,
      :observed_at      => Time.local(2001, 2, 3, 4, 5, 6))
    expected = {
      "event:trigger-operator"      => "eq",
      "event:trigger-operator:json" => '"eq"',
      "event:trigger-level"         => "1",
      "event:trigger-level:json"    => "1",
      "event:observed-level"        => "2",
      "event:observed-level:json"   => "2",
    }
    expected.merge!(@module.add_name("event:created-at", @module.format_datetime(event.created_at)))
    expected.merge!(@module.add_name("event:observed-at", @module.format_datetime(event.observed_at)))
    assert_equal(expected, @module.format_event(event))
  end

  test "format_event, nil" do
    expected = {
      "event:trigger-operator"      => "-",
      "event:trigger-operator:json" => "null",
      "event:trigger-level"         => "-",
      "event:trigger-level:json"    => "null",
      "event:observed-level"        => "-",
      "event:observed-level:json"   => "null",
    }
    expected.merge!(@module.add_name("event:created-at", @module.format_datetime(nil)))
    expected.merge!(@module.add_name("event:observed-at", @module.format_datetime(nil)))
    assert_equal(expected, @module.format_event(Event.new))
    assert_equal(expected, @module.format_event(nil))
  end

  test "format" do
    time  = Time.local(2000, 1, 2, 3, 4, 5)
    event = events(:yuya_pda_ge90_1)
    expected = {}
    expected.merge!(@module.add_name("now", @module.format_datetime(time)))
    expected.merge!(@module.format_event(event))
    expected.merge!(@module.format_device(event.device))
    expected.merge!(@module.format_user(event.device.user))
    assert_equal(expected, @module.format(event, time))
  end

  test "format, nil" do
    time  = Time.local(2000, 1, 2, 3, 4, 5)
    expected = {}
    expected.merge!(@module.add_name("now", @module.format_datetime(time)))
    expected.merge!(@module.format_event(nil))
    expected.merge!(@module.format_device(nil))
    expected.merge!(@module.format_user(nil))
    assert_equal(expected, @module.format(nil, time))
  end

  test "replace_keywords, empty" do
    assert_equal("", @module.replace_keywords("", {}))
  end

  test "replace_keywords" do
    assert_equal(
      "A",
      @module.replace_keywords("{a}", "a" => "A"))
    assert_equal(
      "A,B",
      @module.replace_keywords("{a},{b}", "a" => "A", "b" => "B"))
    assert_equal(
      "A,B,A,B",
      @module.replace_keywords("{a},{b},{a},{b}", "a" => "A", "b" => "B"))
  end
end
