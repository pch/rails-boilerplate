Hashid::Rails.configure do |config|
  config.salt = Rails.application.credentials.hashid_salt!

  # The minimum length of generated hashids
  config.min_hash_length = 8

  config.override_find = false
  config.override_to_param = false
  config.sign_hashids = false
end
