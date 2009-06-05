
ActionController::Routing::Routes.draw do |map|
  IdPattern    = /[0-9]+/
  TokenPattern = /[0-9a-f]+/

  map.root :controller => "home", :action => "index"

  map.with_options :controller => "signup/email" do |email|
    email.connect "signup/email/:action",                      :action => /(index|validate|validated|create|created|activate|activated)/
    email.connect "signup/email/activation/:activation_token", :action => "activation", :activation_token => TokenPattern
  end

  map.with_options :controller => "signup/open_id" do |open_id|
    open_id.connect "signup/open_id/:action", :action => /(index|authenticate|authenticated|create|created)/
  end

  map.connect "auth/:action", :controller => "auth", :action => /(login_complete|logout|logout_complete)/
  map.connect "auth/email/:action", :controller => "auth/email", :action => /(index|login)/
  map.connect "auth/open_id/:action", :controller => "auth/open_id", :action => /(index|login)/

  map.with_options :controller => "devices" do |devices|
    devices.connect "devices/:action",           :action => /(new|create)/
    devices.device  "device/:device_id",         :action => "show", :device_id => IdPattern
    devices.connect "device/:device_id/:action", :action => /(edit|update|delete|destroy|energies|events)/, :device_id => IdPattern
  end

  map.with_options :controller => "triggers", :device_id => IdPattern do |triggers|
    triggers.connect "device/:device_id/triggers/:action",            :action => /(new|create)/
    triggers.connect "device/:device_id/trigger/:trigger_id/:action", :action => /(edit|update|delete|destroy)/, :trigger_id => IdPattern
  end

  map.with_options :controller => "email_actions", :device_id => IdPattern, :trigger_id => IdPattern do |email|
    email.connect "device/:device_id/trigger/:trigger_id/acts/email/:action",                 :action => /(new|create)/
    email.connect "device/:device_id/trigger/:trigger_id/act/email/:email_action_id/:action", :action => /(edit|update|delete|destroy)/, :email_action_id => IdPattern
  end

  map.with_options :controller => "http_actions", :device_id => IdPattern, :trigger_id => IdPattern do |http|
    http.connect "device/:device_id/trigger/:trigger_id/acts/http/:action",                :action => /(new|create)/
    http.connect "device/:device_id/trigger/:trigger_id/act/http/:http_action_id/:action", :action => /(edit|update|delete|destroy)/, :http_action_id => IdPattern
  end

  map.connect "credentials/:action", :controller => "credentials", :action => /(index)/

  map.with_options :controller => "credentials/email" do |email|
    email.connect "credentials/email/:action",                        :action => /(new|create)/
    email.connect "credential/email/:email_credential_id/:action",    :action => /(created|edit_password|update_password|delete|destroy)/, :email_credential_id => IdPattern
    email.connect "credential/email/token/:activation_token/:action", :action => /(activation|activate|activated)/, :activation_token => TokenPattern
  end

  map.with_options :controller => "credentials/open_id" do |open_id|
    open_id.connect "credentials/open_id/:action",                       :action => /(new|create)/
    open_id.connect "credential/open_id/:open_id_credential_id/:action", :action => /(delete|destroy)/, :open_id_credential_id => IdPattern
  end

  map.with_options :controller => "emails" do |emails|
    emails.connect "emails/:action",                        :action => /(new|create)/
    emails.connect "email/:email_address_id/:action",       :action => /(created|delete|destroy)/, :email_address_id => IdPattern
    emails.connect "email/token/:activation_token/:action", :action => /(activation|activate|activated)/, :activation_token => TokenPattern
  end

  map.connect "energies/:action", :controller => "energies", :action => /(index)/
  map.connect "events/:action", :controller => "events", :action => /(index)/
  map.connect "settings/:action", :controller => "settings", :action => /(index|get_nickname|set_nickname)/

  map.connect "device/token/:device_token/:action.rdf", :controller => "device_feeds", :device_token => TokenPattern

  map.connect "device/token/:device_token/energies/update/:level",       :controller => "device_api", :action => "update_energy", :device_token => TokenPattern, :level => /\d+/
  map.connect "device/token/:device_token/energies/update/:level/:time", :controller => "device_api", :action => "update_energy", :device_token => TokenPattern, :level => /\d+/, :time => /\d+/

  map.connect "user/token/:user_token/:action.rdf", :controller => "user_feeds", :user_token => TokenPattern

  map.connect "admin", :controller => "admin/home", :action => "index"

  # MEMO: 下記2行のデフォルトルールをコメントアウトしてrake test:functionalsを
  #       実行することにより、リンクチェックを行うことができる
  map.connect ":controller/:action/:id"
  map.connect ":controller/:action/:id.:format"
end
