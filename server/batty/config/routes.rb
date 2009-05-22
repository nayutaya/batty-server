
ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end
  UserToken   = /[0-9a-f]+/
  DeviceToken = /[0-9a-f]+/
  DeviceId    = /[0-9]+/
  TriggerId   = /[0-9]+/

  map.root :controller => "home", :action => "index"

  map.connect "device/:device_id", :controller => "devices", :action => "show", :device_id => DeviceId
  map.connect "device/:device_id/triggers/new",        :controller => "triggers", :action => "new",    :device_id => DeviceId
  map.connect "device/:device_id/triggers/create",     :controller => "triggers", :action => "create", :device_id => DeviceId
  map.connect "device/:device_id/trigger/:trigger_id", :controller => "triggers", :action => "show",   :device_id => DeviceId, :trigger_id => TriggerId
  map.connect "device/:device_id/trigger/:trigger_id/acts/email/new",    :controller => "email_actions", :action => "new",    :device_id => DeviceId, :trigger_id => TriggerId
  map.connect "device/:device_id/trigger/:trigger_id/acts/email/create", :controller => "email_actions", :action => "create", :device_id => DeviceId, :trigger_id => TriggerId

  map.connect "device/token/:device_token/energies.rdf", :controller => "device_feeds", :action => "energies", :device_token => DeviceToken
  map.connect "device/token/:device_token/events.rdf",   :controller => "device_feeds", :action => "events",   :device_token => DeviceToken
  map.connect "device/token/:device_token/energies/update/:level",       :controller => "device_api", :action => "update_energy", :device_token => DeviceToken, :level => /\d+/
  map.connect "device/token/:device_token/energies/update/:level/:time", :controller => "device_api", :action => "update_energy", :device_token => DeviceToken, :level => /\d+/, :time => /\d+/

  map.connect "user/token/:user_token/energies.rdf", :controller => "user_feeds", :action => "energies", :user_token => UserToken
  map.connect "user/token/:user_token/events.rdf",   :controller => "user_feeds", :action => "events",   :user_token => UserToken

  map.connect "auth/email/:action",  :controller => "email_auth"
  map.connect "auth/openid/:action", :controller => "open_id_auth"

  map.connect "signup/email/:action",                      :controller => "email_signup"
  map.connect "signup/email/activation/:activation_token", :controller => "email_signup", :action => "activation", :activation_token => /[0-9a-f]+/
  map.connect "signup/openid/:action",                     :controller => "open_id_signup"

  map.connect ":controller/:action/:id"
  map.connect ":controller/:action/:id.:format"
end
