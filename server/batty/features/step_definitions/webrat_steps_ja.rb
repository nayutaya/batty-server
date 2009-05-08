# -*- coding: utf-8 -*-
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

# Commonly used webrat steps
# http://github.com/brynary/webrat

Given /^"(.+)" にアクセスしている$/ do |page_name|
  visit path_to(page_name)
end

When /言語は "(.*)"/ do |lang|
  header("ACCEPT_LANGUAGE", lang)
end

When /^"(.+)" へ移動する$/ do |page_name|
  visit path_to(page_name)
end

When /^"([^\"]*)" ボタンをクリックする$/ do |button|
  click_button(button)
end

When /^"([^\"]*)" リンクをクリックする$/ do |link|
  click_link(link)
end

When /^"([^\"]*)" に "([^\"]*)" と入力する$/ do |field, value|
  fill_in(field, :with => value)
end

When /^"([^\"]*)" から "([^\"]*)" を選択する$/ do |field, value|
  select(value, :from => field)
end

# Use this step in conjunction with Rail's datetime_select helper. For example:
# When I select "December 25, 2008 10:00" as the date and time
# TODO 翻訳する
When /^I select "([^\"]*)" as the date and time$/ do |time|
  select_datetime(time)
end

# Use this step when using multiple datetime_select helpers on a page or 
# you want to specify which datetime to select. Given the following view:
#   <%= f.label :preferred %><br />
#   <%= f.datetime_select :preferred %>
#   <%= f.label :alternative %><br />
#   <%= f.datetime_select :alternative %>
# The following steps would fill out the form:
# When I select "November 23, 2004 11:20" as the "Preferred" data and time
# And I select "November 25, 2004 10:30" as the "Alternative" data and time
# TODO 翻訳する
When /^I select "([^\"]*)" as the "([^\"]*)" date and time$/ do |datetime, datetime_label|
  select_datetime(datetime, :from => datetime_label)
end

# Use this step in conjunction with Rail's time_select helper. For example:
# When I select "2:20PM" as the time
# Note: Rail's default time helper provides 24-hour time-- not 12 hour time. Webrat
# will convert the 2:20PM to 14:20 and then select it. 
# TODO 翻訳する
When /^I select "([^\"]*)" as the time$/ do |time|
  select_time(time)
end

# Use this step when using multiple time_select helpers on a page or you want to
# specify the name of the time on the form.  For example:
# When I select "7:30AM" as the "Gym" time
# TODO 翻訳する
When /^I select "([^\"]*)" as the "([^\"]*)" time$/ do |time, time_label|
  select_time(time, :from => time_label)
end

# Use this step in conjunction with Rail's date_select helper.  For example:
# When I select "February 20, 1981" as the date
# TODO 翻訳する
When /^I select "([^\"]*)" as the date$/ do |date|
  select_date(date)
end

# Use this step when using multiple date_select helpers on one page or
# you want to specify the name of the date on the form. For example:
# When I select "April 26, 1982" as the "Date of Birth" date
# TODO 翻訳する
When /^I select "([^\"]*)" as the "([^\"]*)" date$/ do |date, date_label|
  select_date(date, :from => date_label)
end

When /^"([^\"]*)" をチェックする$/ do |field|
  check(field)
end

When /^"([^\"]*)" のチェックを外す$/ do |field|
  uncheck(field)
end

When /^"([^\"]*)" を選択する$/ do |field|
  choose(field)
end

When /^"([^\"]*)" としてファイル "([^\"]*)" を添付する$/ do |field, path|
  attach_file(field, path)
end

Then /^"([^\"]*)" と表示されていること$/ do |text|
  assert_contain text
end

Then /^"([^\"]*)" と表示されていないこと$/ do |text|
  assert_not_contain text
end

Then /^"([^\"]*)" に "([^\"]*)" が含まれていること$/ do |field, value|
      assert_match(/#{value}/, field_labeled(field).value)
  end

Then /^"([^\"]*)" に "([^\"]*)" が含まれていないこと$/ do |field, value|
      assert_no_match(/#{value}/, field_labeled(field).value)
end

Then /^"([^\"]*)" がチェックされていること$/ do |label|
  assert field_labeled(label).checked?
end

Then /^"(.+)" というページが表示されていること$/ do |page_name|
  assert_equal path_to(page_name), URI.parse(current_url).path
end
