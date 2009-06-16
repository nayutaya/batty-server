
module HelpHelper
  HelpTitles = {
    :what_is_keyword => "キーワードとは？",
    :keywords        => "キーワードの一覧",
  }

  def help_title(key)
    return HelpTitles[key.to_sym] || "NOT FOUND"
  end

  def help_link(key, options = {})
    options = options.dup
    show_icon  = (options.delete(:icon)  != false)
    show_title = (options.delete(:title) != false)
    raise(ArgumentError) unless options.empty?

    title = help_title(key)

    anchor =
      case [show_icon, show_title]
      when [true , true ] then help_icon(title) + " " + h(title)
      when [true , false] then help_icon(title)
      when [false, true ] then h(title)
      else ""
      end

    return link_to(anchor, :controller => "help", :action => key)
  end
end
