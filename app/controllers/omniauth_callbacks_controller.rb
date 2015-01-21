class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  before_action :oauth_user

  def facebook
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

  def twitter
  end

  def github
  end

  def vkontakte
  end

  private
  def oauth_user
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'facebook') if is_navigational_format?
    else
      session[:password] = @user.password
      session[:email] = @user.email
      auth = @user.authorizations.first
      session[:provider] = auth.provider
      session[:uid] = auth.uid
      redirect_to finish_signup_path
    end
  end

end