# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_openid1_session',
  :secret      => 'd334de70dfdc93b814025dab5f2539d8c2899af7b60bb85a9e5609e75a585f368599c4025b4aa737a65973663e4fa091799ea8a3c749fa80e522643330ef9de2'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
