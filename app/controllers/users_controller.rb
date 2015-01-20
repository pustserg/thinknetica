class UsersController < ApplicationController

  before_action :set_user

  authorize_resource

  def show
    @questions = @user.questions
    @answers = @user.answers
    @comments = @user.comments
  end

  def update
    @user.update(user_params)
    respond_with(@user)
  end

  def finish_signup
    if request.patch? && params[:user]
      existed_user = User.find_by(email: params[:user][:email])
      if existed_user
        existed_user.create_authorization(@user.authorizations.first)
        @user.destroy
        sign_in_and_redirect existed_user, event: :authentication
      else
        if @user.update(user_params)
          sign_in_and_redirect @user, event: :authentication
        end
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email)
  end

end
