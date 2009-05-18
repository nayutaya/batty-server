
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
  DeviceToken = /[0-9a-f]+/

  map.root :controller => "home", :action => "index"

  map.connect "device/:device_token", :controller => "devices", :action => "show", :device_token => DeviceToken

  map.connect "device/:device_token/energies.rdf", :controller => "device_feeds", :action => "energies", :device_token => /[0-9a-f]+/
  map.connect "device/:device_token/events.rdf",   :controller => "device_feeds", :action => "events",   :device_token => /[0-9a-f]+/

  map.connect "device/:device_token/energies/update/:level",       :controller => "device_api", :action => "update_energy", :device_token => /[0-9a-f]+/
  map.connect "device/:device_token/energies/update/:level/:time", :controller => "device_api", :action => "update_energy", :device_token => /[0-9a-f]+/, :time => /\d+/

  map.connect "user/:user_token/energies.rdf", :controller => "user_feeds", :action => "energies", :user_token => /[0-9a-f]+/
  map.connect "user/:user_token/events.rdf",   :controller => "user_feeds", :action => "events",   :user_token => /[0-9a-f]+/

  map.connect "auth/email",        :controller => "email_auth", :action => "index"
  map.connect "auth/email/login",  :controller => "email_auth", :action => "login"
  map.connect "auth/openid",       :controller => "open_id_auth", :action => "index"
  map.connect "auth/openid/login", :controller => "open_id_auth", :action => "login"

  map.connect "signup/email",                              :controller => "email_signup", :action => "index"
  map.connect "signup/email/validate",                     :controller => "email_signup", :action => "validate"
  map.connect "signup/email/validated",                    :controller => "email_signup", :action => "validated"
  map.connect "signup/email/create",                       :controller => "email_signup", :action => "create"
  map.connect "signup/email/created",                      :controller => "email_signup", :action => "created"
  map.connect "signup/email/activation/:activation_token", :controller => "email_signup", :action => "activation", :activation_token => /[0-9a-f]+/
  map.connect "signup/email/activate",                     :controller => "email_signup", :action => "activate"
  map.connect "signup/email/activated",                    :controller => "email_signup", :action => "activated"
  map.connect "signup/openid",               :controller => "open_id_signup", :action => "index"
  map.connect "signup/openid/authenticate",  :controller => "open_id_signup", :action => "authenticate"
  map.connect "signup/openid/authenticated", :controller => "open_id_signup", :action => "authenticated"
  map.connect "signup/openid/create",        :controller => "open_id_signup", :action => "create"
  map.connect "signup/openid/created",       :controller => "open_id_signup", :action => "created"

  map.connect ":controller/:action/:id"
  map.connect ":controller/:action/:id.:format"
end
