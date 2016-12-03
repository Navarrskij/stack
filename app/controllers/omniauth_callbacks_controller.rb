class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :provider_sign_in

  def facebook
  end

  def twitter
  end

private

  def provider_sign_in
    auth = request.env['omniauth.auth']
    @user = User.find_for_oauth(request.env["omniauth.auth"])
    if @user && @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: auth.provider.capitalize) if is_navigational_format?
    else
      redirect_to new_user_registration_path, alert: 'Authentication failed. Try again or register'
    end
  end
end