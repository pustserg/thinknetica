class UsersController < ApplicationController

  before_action :set_user, except: :finish_signup

  authorize_resource

  def show
    respond_with(@user)
  end

  def edit
  end

  def update  
    check_code = Devise.friendly_token[0,20]  
    if params[:user][:check_code] && params[:user][:check_code] == check_code
      existed_user = User.find_by(email: params[:user][:email])
      if existed_user
        existed_user.create_authorization(@user.authorizations.first)
        @user.destroy
        sign_in_and_redirect existed_user, event: :authentication
      else
        @user.update!(user_params)
        sign_in_and_redirect @user, event: :authentication
      end
    else
      UserMailer.change_email(@user, params[:user][:email], check_code)
      render :edit
    end
  end

  def finish_signup
    @user = User.new(email: session[:email], password: session[:password], password_confirmation: session[:password])
    @uid = session[:uid]
    @provider = session[:provider]
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email)
  end

end
