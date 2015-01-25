class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  # TEMP_EMAIL_REGEX = /.temp/

  before_action :oauth_user

  def facebook
    # render json: request.env['omniauth.auth']
  end

  def twitter
  end

  def github
  end

  def vkontakte
  end

  private
  def oauth_user
    auth = request.env['omniauth.auth']
    @user = User.find_for_oauth(auth)
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: action_name) if is_navigational_format?
    else
      session[:password] = @user.password
      session[:provider] = auth.provider
      session[:uid] = auth.uid
      redirect_to new_user_registration_path
    end
  end

end