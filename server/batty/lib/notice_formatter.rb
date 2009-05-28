
module NoticeFormatter
  def self.format_date(date)
    return {
      "date"    => date.strftime("%Y-%m-%d"),
      "date:ja" => date.strftime("%Y年%m月%d日"),
      "yyyy"    => date.strftime("%Y"),
      "mm"      => date.strftime("%m"),
      "dd"      => date.strftime("%d"),
    }
  end

  def self.format_time(time)
    return {
      "time"    => time.strftime("%H:%M:%S"),
      "time:ja" => time.strftime("%H時%M分%S秒"),
      "hh"      => time.strftime("%H"),
      "nn"      => time.strftime("%M"),
      "ss"      => time.strftime("%S"),
    }
  end
end
