
ActionController::Routing::Routes.draw do |map|
  UserToken       = /[0-9a-f]+/
  DeviceToken     = /[0-9a-f]+/
  ActivationToken = /[0-9a-f]+/

  DeviceId       = /[0-9]+/
  TriggerId      = /[0-9]+/
  EmailActionId  = /[0-9]+/
  HttpActionId   = /[0-9]+/
  EmailAddressId = /[0-9]+/

  map.root :controller => "home", :action => "index"

  map.with_options :controller => "devices" do |devices|
    devices.connect "devices/:action",           :action => /(new|create)/
    devices.device  "device/:device_id",         :action => "show", :device_id => DeviceId
    devices.connect "device/:device_id/:action", :action => /(edit|update|delete|destroy)/, :device_id => DeviceId
  end

  map.connect "device/:device_id/trigger/:trigger_id/:action", :controller => "triggers", :device_id => DeviceId, :trigger_id => TriggerId
  map.connect "device/:device_id/triggers/:action",            :controller => "triggers", :device_id => DeviceId
  map.connect "device/:device_id/trigger/:trigger_id/act/email/:email_action_id/:action", :controller => "email_actions", :device_id => DeviceId, :trigger_id => TriggerId, :email_action_id => EmailActionId
  map.connect "device/:device_id/trigger/:trigger_id/acts/email/:action", :controller => "email_actions", :device_id => DeviceId, :trigger_id => TriggerId
  map.connect "device/:device_id/trigger/:trigger_id/act/http/:http_action_id/:action", :controller => "http_actions", :device_id => DeviceId, :trigger_id => TriggerId, :http_action_id => HttpActionId
  map.connect "device/:device_id/trigger/:trigger_id/acts/http/:action",  :controller => "http_actions", :device_id => DeviceId, :trigger_id => TriggerId

  map.with_options :controller => "credentials/email" do |email_credentials|
    email_credentials.connect "credential/email/:email_credential_id/:action", :action => /(edit_password|update_password|delete|destroy)/, :email_credential_id => /[0-9]+/
  end

  map.with_options :controller => "credentials/open_id" do |open_id_credentials|
    open_id_credentials.connect "credential/open_id/:open_id_credential_id/:action", :action => /(delete|destroy)/, :open_id_credential_id => /[0-9]+/
  end

  map.connect "email/:email_address_id/:action",       :controller => "emails", :action => /(created|delete|destroy)/, :email_address_id => EmailAddressId
  map.connect "email/token/:activation_token/:action", :controller => "emails", :action => /(activation|activate|activated)/, :activation_token => ActivationToken

  map.connect "device/token/:device_token/:action.rdf", :controller => "device_feeds", :device_token => DeviceToken
  map.connect "device/token/:device_token/energies/update/:level",       :controller => "device_api", :action => "update_energy", :device_token => DeviceToken, :level => /\d+/
  map.connect "device/token/:device_token/energies/update/:level/:time", :controller => "device_api", :action => "update_energy", :device_token => DeviceToken, :level => /\d+/, :time => /\d+/

  map.connect "user/token/:user_token/:action.rdf", :controller => "user_feeds", :user_token => UserToken

  map.namespace :signup do |signup|
    signup.connect "email/activation/:activation_token", :controller => "email", :action => "activation", :activation_token => /[0-9a-f]+/
  end

  map.connect ":controller/:action/:id"
  map.connect ":controller/:action/:id.:format"
end
