class OmniauthController < ApplicationController
  skip_before_filter :check_token_expiration, only: :bancsabadell

  def bancsabadell
    save_credentials!(request.env["omniauth.auth"].credentials)

    redirect_to importing_path
  end
end
