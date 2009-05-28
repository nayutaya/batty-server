
module NoticeFormatter
  def self.add_name(name, hash)
    return hash.inject({}) { |memo, (key, value)|
      memo[name + ":" + key] = value
      memo
    }
  end

  def self.format_date(date)
    return {
      "date"      => date.try(:strftime, "%Y-%m-%d")     || "-",
      "date:json" => date.try(:strftime, '"%Y-%m-%d"')   || "null",
      "date:ja"   => date.try(:strftime, "%Y年%m月%d日") || "-",
      "yyyy"      => date.try(:strftime, "%Y")           || "-",
      "mm"        => date.try(:strftime, "%m")           || "-",
      "dd"        => date.try(:strftime, "%d")           || "-",
    }
  end

  def self.format_time(time)
    return {
      "time"      => time.try(:strftime, "%H:%M:%S")     || "-",
      "time:json" => time.try(:strftime, '"%H:%M:%S"')   || "null",
      "time:ja"   => time.try(:strftime, "%H時%M分%S秒") || "-",
      "hh"        => time.try(:strftime, "%H")           || "-",
      "nn"        => time.try(:strftime, "%M")           || "-",
      "ss"        => time.try(:strftime, "%S")           || "-",
    }
  end

  def self.format_datetime(datetime)
    result = {
      "datetime"      => datetime.try(:strftime, "%Y-%m-%d %H:%M:%S")         || "-",
      "datetime:json" => datetime.try(:strftime, '"%Y-%m-%d %H:%M:%S"')       || "null",
      "datetime:ja"   => datetime.try(:strftime, "%Y年%m月%d日 %H時%M分%S秒") || "-",
    }
    result.merge!(self.format_date(datetime))
    result.merge!(self.format_time(datetime))
    return result
  end

  def self.format_integer_value(value)
    return (value.nil? ? "-" : value.to_s)
  end

  def self.format_integer_json_value(value)
    return (value.nil? ? "null" : value.to_s)
  end

  def self.format_string_value(value)
    return (value.blank? ? "-" : value.to_s)
  end

  def self.format_string_json_value(value)
    return (value.blank? ? "null" : "\"#{value}\"")
  end

  def self.format_user(user)
    return {
      "user:token"         => self.format_string_value(user.try(:user_token)),
      "user:token:json"    => self.format_string_json_value(user.try(:user_token)),
      "user:nickname"      => self.format_string_value(user.try(:nickname)),
      "user:nickname:json" => self.format_string_json_value(user.try(:nickname)),
    }
  end

  def self.format_device(device)
    return {
      "device:token"      => self.format_string_value(device.try(:device_token)),
      "device:token:json" => self.format_string_json_value(device.try(:device_token)),
      "device:name"       => self.format_string_value(device.try(:name)),
      "device:name:json"  => self.format_string_json_value(device.try(:name)),
    }
  end

  def self.format_event(event)
    result = {
      "event:trigger-operator"      => self.format_string_value(event.trigger_operator_symbol),
      "event:trigger-operator:json" => self.format_string_json_value(event.trigger_operator_symbol),
      "event:trigger-level"         => self.format_integer_value(event.trigger_level),
      "event:trigger-level:json"    => self.format_integer_json_value(event.trigger_level),
      "event:observed-level"        => self.format_integer_value(event.observed_level),
      "event:observed-level:json"   => self.format_integer_json_value(event.observed_level),
    }
    result.merge!(self.add_name("event:created-at", self.format_datetime(event.created_at)))
    result.merge!(self.add_name("event:observed-at", self.format_datetime(event.observed_at)))
    return result
  end
end
