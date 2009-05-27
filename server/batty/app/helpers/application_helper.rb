
module ApplicationHelper
  def rss_auto_discovery(options = {})
    options = options.dup
    title = options.delete(:title) || raise(ArgumentError)
    href  = options.delete(:href)  || raise(ArgumentError)
    raise(ArgumentError) unless options.empty?

    return %|<link rel="alternate" type="application/rss+xml" title="#{h(title)}" href="#{h(href)}" />|
  end

  def additional_head(&block)
    @additional_head_html ||= ""
    @additional_head_html  += capture(&block)
  end

  def side_column(&block)
    @side_column_html ||= ""
    @side_column_html  += capture(&block)
  end

  def even_or_odd(index)
    return %w[even odd][index % 2]
  end

  def icon16(path, alt = nil)
    return image_tag(
      path,
      :width  => 16,
      :height => 16,
      :alt    => alt,
      :title  => alt)
  end

  def enable_icon
    return icon16("icons/fam/tick.png", "有効")
  end

  def disable_icon
    return icon16("icons/fam/stop.png", "無効")
  end

  def enable_or_disable_icon(enable)
    return (enable ? enable_icon : disable_icon)
  end

  def add_icon
    return icon16("icons/fam/add.png", "追加")
  end

  def edit_icon
    return icon16("icons/fam/cog.png", "編集")
  end

  def delete_icon
    return icon16("icons/fam/bomb.png", "削除")
  end

  def feed_icon
    return icon16("icons/fam/feed.png", "フィード")
  end

  def yyyymmdd(time, null = "-")
    return time.try(:strftime, "%Y年%m月%d日") || null
  end

  def yyyymmdd_hhmm(time, null = "-")
    return time.try(:strftime, "%Y年%m月%d日 %H時%M分") || null
  end

  def user_nickname(user)
    return (user.nickname.blank? ? h("名無しさん") : h(user.nickname))
  end
end
