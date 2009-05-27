
module ApplicationHelper
  def rss_auto_discovery(options = {})
    options = options.dup
    title = options.delete(:title) || raise(ArgumentError)
    href  = options.delete(:href)  || raise(ArgumentError)
    raise(ArgumentError) unless options.empty?

    return %|<link rel="alternate" type="application/rss+xml" title="#{h(title)}" href="#{h(href)}" />|
  end

  def side_column(&block)
    @side_column_html ||= ""
    @side_column_html  += capture(&block)
  end

  def enable_icon
    return image_tag(
      "icons/fam/tick.png",
      :width  => 16,
      :height => 16,
      :alt    => "有効",
      :title  => "有効")
  end

  def disable_icon
    return image_tag(
      "icons/fam/stop.png",
      :width  => 16,
      :height => 16,
      :alt    => "無効",
      :title  => "無効")
  end

  def enable_or_disable_icon(enable)
    return (enable ? enable_icon : disable_icon)
  end

  def add_icon
    return image_tag(
      "icons/fam/add.png",
      :width  => 16,
      :height => 16,
      :alt    => "追加",
      :title  => "追加")
  end

  def edit_icon
    return image_tag(
      "icons/fam/cog.png",
      :width  => 16,
      :height => 16,
      :alt    => "編集",
      :title  => "編集")
  end

  def delete_icon
    return image_tag(
      "icons/fam/bomb.png",
      :width  => 16,
      :height => 16,
      :alt    => "削除",
      :title  => "削除")
  end

  def feed_icon
    return image_tag(
      "icons/fam/feed.png",
      :width  => 16,
      :height => 16,
      :alt    => "フィード",
      :title  => "フィード")
  end

  def yyyymmdd(date, null = "-")
    return date.try(:strftime, "%Y年%m月%d日") || null
  end

  def user_nickname(user)
    return (user.nickname.blank? ? h("名無しさん") : h(user.nickname))
  end
end
