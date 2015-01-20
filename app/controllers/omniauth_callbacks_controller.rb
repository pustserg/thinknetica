class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  TEMP_EMAIL_REGEX = /.temp/

  def facebook
    # render json: request.env['omniauth.auth']
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'facebook') if is_navigational_format?
    end
  end

  def twitter
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.email =~ USER::TEMP_EMAIL_REGEX
      redirect_to edit_user_path(@user)
    else
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'twitter') if is_navigational_format?
    end
  end

  def github
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.email =~ USER::TEMP_EMAIL_REGEX
      redirect_to edit_user_path(@user)
    else
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'github') if is_navigational_format?
    end
  end

  def vkontakte
        @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.email =~ TEMP_EMAIL_REGEX
      redirect_to edit_user_path(@user)
    else
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'vkontakte') if is_navigational_format?
    end
  end

end