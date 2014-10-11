silence_warnings { OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE if Rails.env.development? }

Rails.application.config.middleware.use OmniAuth::Builder do
    provider :bancsabadell,
      CUSTOM_CONFIG['banc_sabadell']['client_id'],
      CUSTOM_CONFIG['banc_sabadell']['client_secret']
end
