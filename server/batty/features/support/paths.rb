# -*- coding: utf-8 -*-
module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in webrat_steps.rb
  #
  # TODO 日本語でパスの定義を書く
  def path_to(page_name)
    case page_name
    when /\Aダッシュボード\z/, /\Aホームページ\z/
      '/'
    when /\Aメールアドレスによるサインアップ\z/
      url_for(:controller => 'signup/email', :action => 'index')
    when /\AOpenID によるサインアップ\z/
      url_for(:controller => 'signup/open_id', :action => 'index')
    when /the new user page/
      new_user_path

    when /the new signup page/
      new_signup_path

    when /the new signup page/
      new_signup_path

    
    # Add more mappings here.
    # Here is a more fancy example:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
