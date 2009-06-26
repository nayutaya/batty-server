
When /^"([^']*?)" のメールを開く$/ do |address|
  open_email(address)
end

When /^"([^']*?)" の最新のメールを開く$/ do |address|
  open_last_email_for(address)
end

When /^メール中の最初のリンクを開く$/ do
  click_first_link_in_email(current_email)
end

Then /^"([^']*?)" がメールを(\d+)通受信していること$/ do |address, n|
  assert_equal(n.to_i, unread_emails_for(address).size)
end

Then /^メールの件名が "(.*)" となっていること$/ do |text|
  assert_equal(NKF.nkf("I", text), current_email.subject)
end
