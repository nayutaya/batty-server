# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_batty_session',
  :secret      => '3a2384d9071ccd3c238a3bfdb98c364c4f88c64350e4e1f4e06ceb4acbd513f0abad05ab2f9efd237c787d525d8767b793bb4a6c796d1a1ccc944b4369452d28'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
ActionController::Base.session_store = :active_record_store
ActionController::Base.session_options[:expire_after] = 3.days
