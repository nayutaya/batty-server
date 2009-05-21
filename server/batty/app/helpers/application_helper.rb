
module ApplicationHelper
  def enable_icon
    return image_tag("icons/fam/tick.png", :width => 16, :height => 16, :alt => "有効", :title => "有効")
  end

  def disable_icon
    return image_tag("icons/fam/delete.png", :width => 16, :height => 16, :alt => "無効", :title => "無効")
  end

  def enable_or_disable_icon(enable)
    return (enable ? enable_icon : disable_icon)
  end
end
