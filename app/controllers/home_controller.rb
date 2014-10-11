class HomeController < ApplicationController
  skip_before_filter :check_token_expiration, only: :index
end
