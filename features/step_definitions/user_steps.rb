# -*- coding: utf-8 -*-
Given /^the following users:$/ do |users|
  User.create!(users.hashes)
end

When /^"(.+?)" はアクティベーションを実行する$/ do |email|
  credential = EmailCredential.find_by_email(email)
  visit url_for(:cotroller => 'email_signup',
                :action => 'activation',
                :activation_token => credential.activation_token)
end


When /^I delete the (\d+)(?:st|nd|rd|th) user$/ do |pos|
  visit users_url
  within("table > tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following users:$/ do |users|
  users.rows.each_with_index do |row, i|
    row.each_with_index do |cell, j|
      response.should have_selector("table > tr:nth-child(#{i+2}) > td:nth-child(#{j+1})") { |td|
        td.inner_text.should == cell
      }
    end
  end
end
