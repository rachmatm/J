# Be sure to restart your server when you modify this file.

WebClientV2::Application.config.session_store :cookie_store, key: '_web-client_v2_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# WebClientV2::Application.config.session_store :active_record_store


WebClientV2::Application.config.middleware.insert_before(
  ActionDispatch::Session::CookieStore,
  FlashSessionCookieMiddleware,
  '_web-client_v2_session'
)