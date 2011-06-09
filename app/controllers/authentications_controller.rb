class AuthenticationsController < ApplicationController
  def create
    omniauth = request.env["omniauth.auth"]
    
    authentication = Authentication.find_by_provider_and_uid(omniauth["provider"], omniauth["uid"])
    if authentication
      sign_in_and_redirect(:user, authentication.user)
    elsif current_user
      current_user.authentications.create!(:provider => omniauth["provider"], :uid => omniauth["uid"], :token => (omniauth['credentials']['token'] rescue nil))
      redirect_to user_url(current_user)
    else
      user = User.new
      user.apply_omniauth(omniauth)
      if user.save
        sign_in_and_redirect(:user, user)
      else
        # TODO: SEE THIS CASE
        session[:omniauth] = omniauth.except("extra")
        redirect_to new_user_registration_url
      end
    end
  end
end
