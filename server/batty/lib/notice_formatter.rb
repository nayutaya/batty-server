
module NoticeFormatter
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
    return "-" if value.nil?
    return value.to_s
  end

  def self.format_integer_json_value(value)
    return "null" if value.nil?
    return value.to_s
  end
end
