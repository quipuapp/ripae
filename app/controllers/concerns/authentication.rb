module Authentication
  extend ActiveSupport::Concern

  included do
    before_filter :check_token_expiration
    before_filter :set_api_key
  end

  protected

  def token
    session[:token]
  end

  def save_credentials!(credentials)
    session[:token] = credentials.token
    session[:expires_at] = credentials.expires_at
    session[:refresh_token] = credentials.refresh_token
  end

  def check_token_expiration
    refresh_token! if token_expired?
  end

  def token_expired?
    return
    session[:expires_at] <= Time.now.to_i
  end

  def refresh_token!
    return
    refresh_response = RestClient.post("https://developers.bancsabadell.com/AuthServerBS/oauth/token",
                                       grant_type: 'refresh_token', refresh_token: session[:refresh_token],
                                       client_id: CUSTOM_CONFIG['banc_sabadell']['client_id'],
                                       client_secret: CUSTOM_CONFIG['banc_sabadell']['client_secret'])
    refresh_hash = JSON.parse(refresh_response.body)

    session[:token] = refresh_hash['access_token']
    session[:expires_at] = Time.now.to_i + refresh_hash['expires_in'].to_i
  end

  def set_api_key
    if access_token = session[:token]
      BancSabadell.api_key = access_token
    end
  end
end
