# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.

Zooey::Application.config.secret_token = if Rails.env.development? or Rails.env.test?
  'bbed8355967d9e542f84a19b055774a990a701d05f516670823974378d2aefc58a1547b4e7709979c923ffb94a3d2f7e8a08238fbaecf790858e7ecf376ee4e1'
else
  ENV['ZOOEY_SECRET_TOKEN']
end
