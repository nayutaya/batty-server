
ActionController::Routing::Routes.draw do |map|
  UserToken     = /[0-9a-f]+/
  DeviceToken   = /[0-9a-f]+/
  DeviceId      = /[0-9]+/
  TriggerId     = /[0-9]+/
  EmailActionId = /[0-9]+/
  HttpActionId  = /[0-9]+/

  map.root :controller => "home", :action => "index"

  map.connect "devices/:action",   :controller => "devices"
  map.device  "device/:device_id", :controller => "devices", :action => "show", :device_id => DeviceId
  map.connect "device/:device_id/triggers/:action", :controller => "triggers", :device_id => DeviceId
  map.connect "device/:device_id/trigger/:trigger_id/act/email/:email_action_id/:action", :controller => "email_actions", :device_id => DeviceId, :trigger_id => TriggerId, :email_action_id => EmailActionId
  map.connect "device/:device_id/trigger/:trigger_id/acts/email/:action", :controller => "email_actions", :device_id => DeviceId, :trigger_id => TriggerId
  map.connect "device/:device_id/trigger/:trigger_id/act/http/:http_action_id/:action", :controller => "http_actions", :device_id => DeviceId, :trigger_id => TriggerId, :http_action_id => HttpActionId
  map.connect "device/:device_id/trigger/:trigger_id/acts/http/:action",  :controller => "http_actions", :device_id => DeviceId, :trigger_id => TriggerId

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
