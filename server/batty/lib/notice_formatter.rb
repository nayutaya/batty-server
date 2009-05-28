
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
end
