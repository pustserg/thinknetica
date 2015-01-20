class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  TEMP_EMAIL_REGEX = /.temp/

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
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.email =~ TEMP_EMAIL_REGEX
      redirect_to edit_user_path(@user)
    else
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'facebook') if is_navigational_format?
    end
  end

end